// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-tagged-collection-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "Tagged Collection Primitives",
            targets: ["Tagged Collection Primitives"]
        ),
        .library(
            name: "Tagged Collection Primitives Test Support",
            targets: ["Tagged Collection Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-tagged-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-collection-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-index-primitives.git", branch: "main"),
    ],
    targets: [
        // MARK: - Integration
        .target(
            name: "Tagged Collection Primitives",
            dependencies: [
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Collection Protocol Primitives", package: "swift-collection-primitives"),
                .product(name: "Index Primitives", package: "swift-index-primitives"),
            ]
        ),
        // MARK: - Test Support
        .target(
            name: "Tagged Collection Primitives Test Support",
            dependencies: [
                "Tagged Collection Primitives",
                // Test Support spine ([MOD-024]): the TS of the collection dep, which
                // vends Collection.Fixture.Source — a Collection.`Protocol` conformer.
                .product(name: "Collection Primitives Test Support", package: "swift-collection-primitives"),
            ],
            path: "Tests/Support"
        ),
        // MARK: - Tests
        .testTarget(
            name: "Tagged Collection Primitives Tests",
            dependencies: [
                "Tagged Collection Primitives",
                "Tagged Collection Primitives Test Support",
                .product(name: "Collection Primitives Test Support", package: "swift-collection-primitives"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
