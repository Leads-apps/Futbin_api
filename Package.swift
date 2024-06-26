// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Futbin_api",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Futbin_api",
            targets: ["Futbin_api"]),
    ],
    dependencies: [
        .package(name: "SwiftSoup", url: "https://github.com/scinfu/SwiftSoup.git", from: "2.6.1")
    ],
    targets: [
        .target(
            name: "Futbin_api",
            dependencies: ["SwiftSoup"],
            path: "Sources"
        ),
        .testTarget(
            name: "Futbin_apiTests",
            dependencies: ["Futbin_api"]),
    ],
    swiftLanguageVersions: [.v5]
)
