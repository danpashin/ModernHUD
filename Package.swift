// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ModernHUD",
    platforms: [.iOS(.v13), .macCatalyst(.v13)],
    products: [
        .library(name: "ModernHUD", targets: ["ModernHUD"]),
    ],
    targets: [
        .target(name: "ModernHUD"),
    ]
)
