// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Swift Package Manager support for tobias Flutter plugin.
// 
// By default, this package uses the Standard AlipaySDK variant.
// To use the NoUtdid variant, modify this file to:
// 1. Change the binaryTarget path from "AlipaySDK/Standard" to "AlipaySDK/NoUtdid"
// 2. Change the bundle resource path accordingly

import PackageDescription

let configs = readPubspecConfig()
print("Parsed pubspec.yaml config: \(String(describing: configs))")

let package = Package(
    name: "tobias",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "tobias",
            targets: ["tobias"]
        ),
    ],
    dependencies: [
            .package(path: "AlipaySDK/Standard/AlipaySDK.xcframework")
    ],
    targets: [
        // Main target
        .target(
            name: "tobias",
            dependencies: [
                .byName(name: "AlipaySDK")
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
                // Default: Standard bundle
                // To use NoUtdid variant, change to "../AlipaySDK/NoUtdid/AlipaySDK.bundle"
                .process("AlipaySDK/Standard/AlipaySDK.bundle"),
            ],
            linkerSettings: [
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("CoreTelephony"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("CoreText"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("UIKit"),
                .linkedFramework("Foundation"),
                .linkedFramework("CFNetwork"),
                .linkedFramework("CoreMotion"),
                .linkedFramework("WebKit"),
                .linkedLibrary("z"),
                .linkedLibrary("c++"),
            ]
        ),
        .binaryTarget(name: "AlipaySDK", path: "AlipaySDK/Standard/AlipaySDK.xcframework"),
    ]
)

func parseYAML(_ content: String) -> [String: Any]? {
    var config: [String: Any] = [:]
    var fluwxConfig: [String: Any] = [:]
    var iosConfig: [String: Any] = [:]

    let lines = content.components(separatedBy: .newlines)
    var inFluwxSection = false
    var inIosSection = false

    for line in lines {
        let trimmed = line.trimmingCharacters(in: .whitespaces)

        // 跳过注释和空行
        if trimmed.isEmpty || trimmed.hasPrefix("#") {
            continue
        }

        // 检测缩进级别
        let indent = line.count - line.trimmingCharacters(in: .whitespaces).count

        // 检测 fluwx 配置块
        if trimmed == "tobias:" {
            inFluwxSection = true
            inIosSection = false
            continue
        }

        // 检测 ios 子配置块
        if trimmed == "ios:" && inFluwxSection && indent == 2 {
            inIosSection = true
            continue
        }

        // 如果不在 fluwx 部分，跳过
        if !inFluwxSection {
            continue
        }

        // 解析键值对
        if let colonIndex = trimmed.firstIndex(of: ":") {
            let key = String(trimmed[..<colonIndex]).trimmingCharacters(in: .whitespaces)
            var value = String(trimmed[trimmed.index(after: colonIndex)...]).trimmingCharacters(in: .whitespaces)

            // 移除引号
            if value.hasPrefix("\"") && value.hasSuffix("\"") {
                value = String(value.dropFirst().dropLast())
            }

            // 处理布尔值
            let boolValue: Bool?
            if value == "true" {
                boolValue = true
            } else if value == "false" {
                boolValue = false
            } else {
                boolValue = nil
            }

            if inIosSection {
                iosConfig[key] = boolValue ?? value
            } else {
                fluwxConfig[key] = boolValue ?? value
            }
        }

        // 如果缩进回到顶层，退出 ios 部分
        if inIosSection && indent <= 2 && !trimmed.hasPrefix("ios:") {
            inIosSection = false
        }
    }

    if !iosConfig.isEmpty {
        fluwxConfig["ios"] = iosConfig
    }

    if !fluwxConfig.isEmpty {
        config["fluwx"] = fluwxConfig
    }

    return config.isEmpty ? nil : config
}

/// 读取 pubspec.yaml 文件并解析配置
func readPubspecConfig() -> [String: Any]? {
    let fileManager = FileManager.default
    let currentPath = fileManager.currentDirectoryPath

    // 尝试多个可能的路径
    let possiblePaths = [
        "\(currentPath)/../pubspec.yaml",           // 从 ios/ 目录
        "\(currentPath)/pubspec.yaml",              // 从项目根目录
        "\(fileManager.currentDirectoryPath)/../pubspec.yaml",
    ]

    for path in possiblePaths {
        if let data = fileManager.contents(atPath: path),
           let content = String(data: data, encoding: .utf8) {
            return parseYAML(content)
        }
    }

    return nil
}

