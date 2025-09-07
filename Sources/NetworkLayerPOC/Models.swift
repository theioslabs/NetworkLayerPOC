// Models.swift
import Foundation

public struct User: Decodable, Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let email: String
}

public struct Post: Decodable, Equatable, Identifiable {
    public let id: Int
    public let title: String
    public let body: String
    public let userId: Int
}
