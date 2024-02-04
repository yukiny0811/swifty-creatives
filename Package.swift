// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

extension Target {
    var asDependency: Target.Dependency {
        Target.Dependency(stringLiteral: self.name)
    }
}

let dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.15.2"),
    .package(url: "https://github.com/yukiny0811/SimpleSimdSwift", from: "1.0.1"),
    .package(url: "https://github.com/yukiny0811/FontVertexBuilder", from: "1.1.1"),
    .package(url: "https://github.com/yukiny0811/EasyMetalShader.git", from: "3.1.1"),
    .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
]

enum CorePackage {
    static let SnapshotTesting = Target.Dependency.product(name: "SnapshotTesting", package: "swift-snapshot-testing")
    static let SimpleSimdSwift = Target.Dependency.product(name: "SimpleSimdSwift", package: "SimpleSimdSwift")
    static let FontVertexBuilder = Target.Dependency.product(name: "FontVertexBuilder", package: "FontVertexBuilder")
    static let EasyMetalShader = Target.Dependency.product(name: "EasyMetalShader", package: "EasyMetalShader")
    static let SwiftSyntaxMacros = Target.Dependency.product(name: "SwiftSyntaxMacros", package: "swift-syntax")
    static let SwiftCompilerPlugin = Target.Dependency.product(name: "SwiftCompilerPlugin", package: "swift-syntax")
}

let SwiftyCreativesSound = Target.target(
    name: "SwiftyCreativesSound",
    dependencies: [],
    path: "Sources/SwiftyCreativesSound"
)

let SwiftyCreativesMacro = Target.macro(
    name: "SwiftyCreativesMacro",
    dependencies: [
        CorePackage.SwiftSyntaxMacros,
        CorePackage.SwiftCompilerPlugin,
    ],
    path: "Sources/SwiftyCreativesMacro"
)

let SwiftyCreatives = Target.target(
    name: "SwiftyCreatives",
    dependencies: [
        CorePackage.SimpleSimdSwift,
        CorePackage.FontVertexBuilder,
        CorePackage.EasyMetalShader,
        SwiftyCreativesSound.asDependency,
        SwiftyCreativesMacro.asDependency,
    ],
    path: "Sources/SwiftyCreatives",
    resources: [
        .process("Resources")
    ]
)

let SwiftyCreativesTests = Target.testTarget(
    name: "SwiftyCreativesTests",
    dependencies: [
        SwiftyCreatives.asDependency,
        CorePackage.SnapshotTesting,
    ],
    path: "Tests/SwiftyCreativesTests"
)

let package = Package(
    name: "SwiftyCreatives",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "SwiftyCreatives",
            targets: ["SwiftyCreatives"]
        )
    ],
    dependencies: dependencies,
    targets: [
        SwiftyCreativesSound,
        SwiftyCreativesMacro,
        SwiftyCreatives,
        SwiftyCreativesTests,
    ]
)
