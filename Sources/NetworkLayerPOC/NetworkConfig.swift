// NetworkConfig.swift
import Foundation

public struct NetworkConfig {
    public let baseURL: URL
    public let defaultHeaders: [String: String]
    public let decoder: JSONDecoder
    public let encoder: JSONEncoder

    public init(baseURL: URL,
                defaultHeaders: [String: String] = ["Accept": "application/json"],
                decoder: JSONDecoder = JSONDecoder(),
                encoder: JSONEncoder = JSONEncoder()) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.decoder = decoder
        self.encoder = encoder
    }
}
