// Fixtures.swift
import Foundation

let usersJSON = """
[
  { "id": 1, "name": "Alice", "email": "alice@example.com" },
  { "id": 2, "name": "Bob",   "email": "bob@example.com"   }
]
""".data(using: .utf8)!

let createdPostJSON = """
{ "id": 101, "title": "Hello", "body": "World", "userId": 1 }
""".data(using: .utf8)!
