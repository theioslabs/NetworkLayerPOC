// ExampleView.swift
#if canImport(SwiftUI)
import SwiftUI

public struct ExampleView: View {
    @StateObject private var vm = ExampleViewModel(client: makePOCClient())

    public init() {}

    public var body: some View {
        NavigationView {
            List {
                Section("Users") {
                    ForEach(vm.users) { user in
                        VStack(alignment: .leading) {
                            Text(user.name).font(.headline)
                            Text(user.email).font(.subheadline)
                        }
                    }
                    Button("Load Users") { vm.loadUsers() }
                }

                Section("Create Post") {
                    if let post = vm.createdPost {
                        VStack(alignment: .leading) {
                            Text(post.title).font(.headline)
                            Text(post.body).font(.subheadline)
                        }
                    }
                    Button("Create via Combine") { vm.createPostCombine() }
                }

                if let err = vm.errorMessage {
                    Section("Error") { Text(err).foregroundColor(.red) }
                }
            }
            .navigationTitle("Network Layer POC")
            .onAppear { vm.loadUsers() }
        }
    }
}

#Preview {
    ExampleView()
}
#endif
