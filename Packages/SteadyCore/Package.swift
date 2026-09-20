// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SteadyCore",
    // macOS is not a shipping platform. It is here only because `swift test`
    // builds for the host; without it the host target falls back to macOS 12,
    // which predates SwiftData and breaks the @Model conformances. v14 is the
    // true floor (SwiftData's minimum) — deliberately not pinned to .v26, so
    // tests stay runnable on older machines and CI.
    platforms: [.iOS(.v26), .watchOS(.v26), .macOS(.v14)],
    products: [
        .library(name: "SteadyCore", targets: ["SteadyCore"]),
    ],
    targets: [
        .target(
            name: "SteadyCore",
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "SteadyCoreTests",
            dependencies: ["SteadyCore"]
        ),
    ]
)
