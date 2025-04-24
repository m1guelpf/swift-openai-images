// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "OpenAIImages",
    platforms: [
        .iOS(.v17),
        .tvOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .visionOS(.v1),
        .macCatalyst(.v17),
    ],
    products: [
        .library(name: "OpenAIImages", type: .static, targets: ["OpenAIImages"]),
    ],
    targets: [
        .target(name: "OpenAIImages", path: "./src"),
    ]
)
