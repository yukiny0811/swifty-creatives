// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyCreatives",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftyCreatives",
            targets: ["SwiftyCreatives"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftyCreatives",
            dependencies: [],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "SwiftyCreativesTests",
            dependencies: ["SwiftyCreatives"]
        )
    ]
)
