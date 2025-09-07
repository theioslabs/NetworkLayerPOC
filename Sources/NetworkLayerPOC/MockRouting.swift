// MockRouting.swift
import Foundation

func installMockRouting() {
    MockURLProtocol.handler = { request in
        guard let url = request.url else { throw APIError.invalidURL }
        switch (request.httpMethod ?? "GET", url.path) {
        case ("GET", "/users"):
            return (200, usersJSON)
        case ("POST", "/posts"):
            return (201, createdPostJSON)
        default:
            return (404, Data())
        }
    }
}
