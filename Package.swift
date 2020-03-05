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
        .package(url: "https://github.com/elegantchaos/Logger.git", from: "1.5.2"),
    ],
    targets: [
        .target(
            name: "ApplicationExtensions",
            dependencies: ["LoggerKit"]),
        .testTarget(
            name: "ApplicationExtensionsTests",
            dependencies: ["ApplicationExtensions"]),
    ]
)
