// RequestBuilder.swift
import Foundation

public struct RequestBuilder {
    let config: NetworkConfig

    public init(config: NetworkConfig) { self.config = config }

    public func makeRequest<E: Endpoint>(_ endpoint: E) throws -> URLRequest {
        guard var components = URLComponents(url: config.baseURL, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        components.path = components.path.appending(endpoint.path)
        components.queryItems = endpoint.query?.nilIfEmpty()

        guard let url = components.url else { throw APIError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        // headers
        (config.defaultHeaders.merging(endpoint.headers ?? [:]) { _, new in new })
            .forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        // body
        if let body = endpoint.body {
            request.httpBody = try config.encoder.encode(body)
        }

        return request
    }
}

fileprivate extension Array where Element == URLQueryItem {
    func nilIfEmpty() -> [URLQueryItem]? { isEmpty ? nil : self }
}
