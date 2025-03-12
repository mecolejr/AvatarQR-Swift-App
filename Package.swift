// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AvatarQR",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AvatarQRLib",
            targets: ["AvatarQRLib"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Library target containing all the model and view code
        .target(
            name: "AvatarQRLib",
            dependencies: [],
            path: "Sources",
            exclude: ["AvatarQRApp.swift"]),
            
        // Test target
        .testTarget(
            name: "AvatarQRTests",
            dependencies: ["AvatarQRLib"],
            path: "Tests"),
    ]
) 