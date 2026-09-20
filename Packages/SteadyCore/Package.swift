// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SteadyCore",
    platforms: [.iOS(.v26), .watchOS(.v26)],
    products: [
        .library(name: "SteadyCore", targets: ["SteadyCore"])
    ],
    targets: [
        .target(
            name: "SteadyCore",
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "SteadyCoreTests",
            dependencies: ["SteadyCore"]
        )
    ]
)
