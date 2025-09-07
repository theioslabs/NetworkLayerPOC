// TCAUsersFeature.swift
#if canImport(ComposableArchitecture)
import Foundation
import ComposableArchitecture

@Reducer
public struct UsersFeature {
    @ObservableState
    public struct State: Equatable {
        public var users: [User] = []
        public var isLoading = false
        public var error: String?
        public init() {}
    }

    public enum Action: Equatable, Sendable {
        case onAppear
        case usersResponse(Result<[User], APIError>)
    }

    let client: NetworkClientProtocol

    public init(client: NetworkClientProtocol) {
        self.client = client
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    do {
                        let users: [User] = try await client.fetch(UsersEndpoint())
                        await send(.usersResponse(.success(users)))
                    } catch let err as APIError {
                        await send(.usersResponse(.failure(err)))
                    } catch {
                        await send(.usersResponse(.failure(.transport(error))))
                    }
                }
            case .usersResponse(let result):
                state.isLoading = false
                switch result {
                case .success(let list): state.users = list
                case .failure(let err): state.error = err.localizedDescription
                }
                return .none
            }
        }
    }
}
#endif
