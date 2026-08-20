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
    targets: [
        .target(
            name: "tobias",
            dependencies: ["AlipaySDK"],
            resources: [
                .process("Resources/PrivacyInfo.xcprivacy"),
                .copy("Resources/AlipaySDK.bundle")
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
        ),
        .binaryTarget(
            name: "AlipaySDK",
            path: "AlipaySDK.xcframework"
        )
    ]
)
