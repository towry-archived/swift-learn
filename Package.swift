// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "swift-lean",
    products: [
        .executable(name: "SwiftLean", targets: ["SwiftLean"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "SwiftLean", path: "./Sources/Play")
    ]
)
