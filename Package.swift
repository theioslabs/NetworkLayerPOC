// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NetworkLayerPOC",
    platforms: [
        .iOS(.v16), .macOS(.v13)
    ],
    products: [
        .library(name: "NetworkLayerPOC", targets: ["NetworkLayerPOC"]),
    ],
    dependencies: [
        // Add TCA optionally in your host app if you want
        // .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.10.0")
    ],
    targets: [
        .target(
            name: "NetworkLayerPOC",
            dependencies: [
                // "ComposableArchitecture"
            ],
            path: "Sources/NetworkLayerPOC"
        )
    ]
)
