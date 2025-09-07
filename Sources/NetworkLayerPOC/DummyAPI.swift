// DummyAPI.swift
import Foundation

struct UsersEndpoint: Endpoint {
    let path = "/users"
    let method: HTTPMethod = .GET
    typealias Body = EmptyBody
}

struct CreatePostEndpoint: Endpoint {
    let title: String
    let bodyText: String
    let userId: Int

    var path: String { "/posts" }
    var method: HTTPMethod { .POST }
    var headers: [String: String]? { ["Content-Type": "application/json"] }

    struct Payload: Encodable { let title: String; let body: String; let userId: Int }
    typealias Body = Payload
    var body: Payload? { .init(title: title, body: bodyText, userId: userId) }
}
