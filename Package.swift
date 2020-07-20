// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "ApplicationExtensions",
    platforms: [
        .macOS(.v10_13), .iOS(.v12), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "ApplicationExtensions",
            targets: ["ApplicationExtensions"]),
    ],
    dependencies: [
        .package(url: "https://github.com/elegantchaos/Bundles.git", from: "1.0.5"),
        .package(url: "https://github.com/elegantchaos/CollectionExtensions.git", from: "1.0.2"),
        .package(url: "https://github.com/elegantchaos/Logger.git", from: "1.5.5"),
    ],
    targets: [
        .target(
            name: "ApplicationExtensions",
            dependencies: ["Bundles", "LoggerKit", "CollectionExtensions"]),
        .testTarget(
            name: "ApplicationExtensionsTests",
            dependencies: ["ApplicationExtensions"]),
    ]
)
