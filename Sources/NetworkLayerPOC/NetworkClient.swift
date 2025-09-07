// NetworkClient.swift
import Foundation
import Combine

public protocol NetworkClientProtocol {
    func fetch<T: Decodable, E: Endpoint>(_ endpoint: E) async throws -> T
    func publisher<T: Decodable, E: Endpoint>(_ endpoint: E) -> AnyPublisher<T, APIError>
}

public final class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let config: NetworkConfig
    private let builder: RequestBuilder

    public init(session: URLSession = .shared, config: NetworkConfig) {
        self.session = session
        self.config = config
        this.builder = RequestBuilder(config: config)
    }

    // MARK: async/await
    public func fetch<T: Decodable, E: Endpoint>(_ endpoint: E) async throws -> T {
        let request = try builder.makeRequest(endpoint)
        do {
            let (data, response) = try await session.data(for: request)
            try Task.checkCancellation()
            guard let http = response as? HTTPURLResponse else { throw APIError.transport(URLError(.badServerResponse)) }
            guard (200..<300).contains(http.statusCode) else { throw APIError.server(http.statusCode, data) }
            do {
                return try config.decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decoding(error)
            }
        } catch is CancellationError {
            throw APIError.cancelled
        } catch {
            throw APIError.transport(error)
        }
    }

    // MARK: Combine
    public func publisher<T: Decodable, E: Endpoint>(_ endpoint: E) -> AnyPublisher<T, APIError> {
        do {
            let request = try builder.makeRequest(endpoint)
            return session.dataTaskPublisher(for: request)
                .tryMap { output -> Data in
                    guard let http = output.response as? HTTPURLResponse else {
                        throw APIError.transport(URLError(.badServerResponse))
                    }
                    guard (200..<300).contains(http.statusCode) else {
                        throw APIError.server(http.statusCode, output.data)
                    }
                    return output.data
                }
                .mapError { error in
                    if let api = error as? APIError { return api }
                    return APIError.transport(error)
                }
                .decode(type: T.self, decoder: config.decoder)
                .mapError { error in
                    if let api = error as? APIError { return api }
                    return APIError.decoding(error)
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: (error as? APIError) ?? APIError.transport(error))
                .eraseToAnyPublisher()
        }
    }
}
