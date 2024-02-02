// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyCreatives",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SwiftyCreatives",
            targets: ["SwiftyCreatives"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.15.2")
    ],
    targets: [
        .target(
            name: "SwiftyCreatives",
            dependencies: [],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "SwiftyCreativesTests",
            dependencies: [
                "SwiftyCreatives",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        )
    ]
)
