// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "tobias",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "tobias", targets: ["tobias"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/JarvanMo/AliPaySDK-SPM.git", exact: "15.8.42")
    ],
    targets: [
        .target(
            name: "tobias",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "AlipaySDK", package: "AliPaySDK-SPM")
            ],
            resources: [
                .process("Resources/PrivacyInfo.xcprivacy")
            ],
            linkerSettings: [
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("CoreTelephony"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("CoreText"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("UIKit"),
                .linkedFramework("Foundation"),
                .linkedFramework("Network"),
                .linkedFramework("CoreMotion"),
                .linkedFramework("WebKit"),
                .linkedLibrary("z"),
                .linkedLibrary("c++")
            ]
        )
    ]
)
