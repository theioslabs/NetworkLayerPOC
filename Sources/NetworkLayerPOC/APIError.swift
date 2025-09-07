// APIError.swift
public enum APIError: Error, LocalizedError, Equatable {
    case invalidURL
    case transport(Error)       // URLSession errors
    case server(Int, Data?)     // non-2xx + payload
    case decoding(Error)        // JSON decoding
    case cancelled

    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .transport(let err): return "Transport error: \(err.localizedDescription)"
        case .server(let code, _): return "Server error: HTTP \(code)."
        case .decoding(let err): return "Decoding error: \(err.localizedDescription)"
        case .cancelled: return "Request was cancelled."
        }
    }
}
