// ExampleUsage.swift
import Foundation
import Combine

@MainActor
public final class ExampleViewModel: ObservableObject {
    @Published public var users: [User] = []
    @Published public var createdPost: Post?
    @Published public var errorMessage: String?

    private let client: NetworkClientProtocol
    private var bag = Set<AnyCancellable>()

    public init(client: NetworkClientProtocol) {
        self.client = client
    }

    // async/await
    public func loadUsers() {
        Task {
            do {
                let list: [User] = try await client.fetch(UsersEndpoint())
                users = list
            } catch {
                errorMessage = (error as? APIError)?.localizedDescription ?? error.localizedDescription
            }
        }
    }

    // Combine
    public func createPostCombine() {
        let ep = CreatePostEndpoint(title: "Hello", bodyText: "World", userId: 1)
        client.publisher(ep)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let err) = completion {
                    self?.errorMessage = err.localizedDescription
                }
            } receiveValue: { [weak self] (post: Post) in
                self?.createdPost = post
            }
            .store(in: &bag)
    }
}

public func makePOCClient() -> NetworkClient {
    installMockRouting()
    let session = makeMockSession()
    let base = URL(string: "https://mock.local")! // host doesn't matter (intercepted)
    var decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    let config = NetworkConfig(baseURL: base, decoder: decoder)
    return NetworkClient(session: session, config: config)
}
