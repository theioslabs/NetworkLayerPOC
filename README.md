# NetworkLayerPOC

A ready-to-push sample **Network Layer** for iOS using **URLSession + async/await + Swift Concurrency** with an optional **Combine** API. Includes a zero-internet **mock server** via `URLProtocol` and a demo SwiftUI view.

> Built for iOS Labs community exercises. Plug-and-play with your TCA features.

## Features
- Clean `Endpoint` abstraction
- Async/await `fetch` + Combine `publisher`
- Strong error typing (`APIError`)
- URLProtocol-based mock routing (no network required)
- Demo `ExampleView` to preview users + create post
- TCA integration sketch (opt-in)

## Quickstart (Xcode App)
1. Create a new **iOS App (SwiftUI)** project (iOS 16+).
2. **File > Add Packages…** (optional) OR drag this folder into your project as a local package.
3. Add `import NetworkLayerPOC` in your app.
4. In your app’s root view, use the demo client:
   ```swift
   import SwiftUI
   import NetworkLayerPOC

   @main
   struct DemoApp: App {
       var body: some Scene {
           WindowGroup {
               ExampleView() // uses mocked networking
           }
       }
   }
   ```
5. Run. You should see two mock users and a button to create a post.

## Using with TCA
Use `NetworkClientProtocol` inside your reducer effects. See `TCAUsersFeature.swift` for a tiny example sketch (guarded with `#if canImport(ComposableArchitecture)`).

## Folder Structure
```
NetworkLayerPOC/
├─ Package.swift
├─ README.md
├─ LICENSE
├─ .gitignore
└─ Sources/
   └─ NetworkLayerPOC/
      ├─ HTTPMethod.swift
      ├─ APIError.swift
      ├─ Endpoint.swift
      ├─ NetworkConfig.swift
      ├─ RequestBuilder.swift
      ├─ NetworkClient.swift
      ├─ Models.swift
      ├─ DummyAPI.swift
      ├─ MockURLProtocol.swift
      ├─ MockSessionFactory.swift
      ├─ Fixtures.swift
      ├─ MockRouting.swift
      ├─ ExampleUsage.swift
      ├─ ExampleView.swift
      └─ TCAUsersFeature.swift
```

## Notes
- This package compiles standalone, but `ExampleView` needs SwiftUI (iOS/macOS).
- Replace `mock.local` with your real base URL when connecting to live APIs and remove the mock protocol.

## License
MIT
