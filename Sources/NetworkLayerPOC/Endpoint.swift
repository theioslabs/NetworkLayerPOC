// Endpoint.swift
import Foundation

public protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var query: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    associatedtype Body: Encodable
    var body: Body? { get }
}

public extension Endpoint {
    var query: [URLQueryItem]? { nil }
    var headers: [String: String]? { nil }
    var body: EmptyBody? { nil } // default: no body
}

public struct EmptyBody: Encodable {}
