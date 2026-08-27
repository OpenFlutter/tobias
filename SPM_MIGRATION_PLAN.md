# tobias iOS Swift Package Manager 迁移计划

目标：为 iOS 端增加 Swift Package Manager 支持，保留 CocoaPods 双轨并存，同时移除 `tobias_setup.rb` 自动改写宿主工程的行为，并下线 NoUtdid 变体。

已确定的三条决策：

1. **双轨并存**：保留 `ios/tobias.podspec`，新增 `ios/tobias/Package.swift`。开启 SPM 的项目走 SPM，未开启的仍走 Pod。
2. **只保留 Standard 版 AlipaySDK**：删除 `NoUtdid` 变体与 `no_utdid` 配置项，SPM 下只有一个 `binaryTarget`。
3. **移除 `tobias_setup.rb`**：不再自动修改 Runner 的 Info.plist / entitlements，改为 README 文档说明由用户手动配置。

决策 2、3 都是 breaking change，需要在 CHANGELOG 与 README 显著位置说明。

## 进度

| 阶段 | 状态 |
|---|---|
| 0 可行性验证 | ⬜ 待做（需要 macOS + Xcode） |
| 1 删除 NoUtdid | ✅ 已完成 |
| 2 目录重构 | ✅ 已完成 |
| 3 Package.swift | ✅ 已完成 |
| 4 移除 setup.rb + 文档 | ✅ 已完成 |
| 5 example 与测试矩阵 | ⬜ 待做（需要 macOS + 真机） |
| 6 CI 与发布 | 🟡 CI 已改，发布待做 |

阶段 0 原计划先行验证，实际因为无法在当前环境跑 Xcode，改为先完成代码改动，验证与阶段 5 合并执行。

---

## 一、现状与约束

| 项 | 现状 | SPM 下的处理 |
|---|---|---|
| 源码 | `ios/Classes/TobiasPlugin.{h,m}` | 移到 `Sources/tobias/`，公开头文件进 `include/tobias/` |
| 二进制 SDK | `AlipaySDK/{Standard,NoUtdid}/AlipaySDK.xcframework` | 只留 Standard，`binaryTarget` 路径必须在 package 目录内 |
| 资源 bundle | `AlipaySDK.bundle` | 移入 target 目录，`.copy` 声明 |
| 隐私清单 | `resource_bundles: tobias_privacy` | SPM 自动生成 `tobias_tobias.bundle`，bundle 名会变 |
| 变体选择 | podspec 读宿主 `pubspec.yaml` 选 subspec | **整体删除**，subspec 机制不再需要 |
| 工程配置 | podspec 调用 `tobias_setup.rb` 写 Info.plist / entitlements | **整体删除**，manifest 在沙箱中运行本就无法写文件 |
| 部署目标 | podspec `ios 9.0` | SPM 设 `.v13`（与 example Podfile 的 13.0 一致） |

砍掉 NoUtdid 之后，原本最大的风险（manifest 无法可靠定位宿主 `pubspec.yaml`，因为插件在真实工程中位于 pub cache 符号链接下）随之消失，podspec 里的 Ruby 逻辑也可以全部清空。剩余不确定性集中在二进制链接与资源查找。

---

## 阶段 0：可行性验证（0.5 天）

在临时分支上写一个最小 `Package.swift` 验证两点：

1. **`binaryTarget` + 静态 xcframework 的链接行为**：AlipaySDK 是静态 framework，确认 SPM 下 `-ObjC`、`z`、`c++` 链接正常，Objective-C 类别与符号不被裁掉。
2. **`AlipaySDK.bundle` 的查找路径**：SDK 内部通过 `mainBundle` 或 framework bundle 查找资源，确认 SPM 打包后支付页面的图片与 `bridge.js` 能正常加载。这是最容易出问题的一环，必须真机 + 模拟器各跑一次实际支付流程。

产出：确认 `.copy` 与 `linkerSettings` 的最终写法。

---

## 阶段 1：删除 NoUtdid（0.5 天）

先做这一步，后续所有阶段的工作量都会减半。

- `git rm -r ios/AlipaySDK/NoUtdid`（约 8MB）。
- podspec 去掉 `normal` / `no_utdid` 两个 subspec 与 `default_subspec`，把 frameworks、libraries、resource、vendored_frameworks 提升到顶层。
- 移除读取 `cfg['tobias']['no_utdid']` 的 Ruby 逻辑。
- README / README_CN 删除 `no_utdid` 相关说明；`example/pubspec.yaml` 删除被注释的 `no_utdid` 行。
- CHANGELOG 标注：不再提供 NoUtdid 版本，遇到 utdid 冲突的用户需另寻方案（如与冲突方协调依赖，或锁定在 5.x）。

验收：example 用 CocoaPods 编译运行、能拉起支付宝。

---

## 阶段 2：目录重构（0.5 天）

按 Flutter 官方迁移建议调整布局，Pod 与 SPM 共用同一份文件：

```
ios/
  tobias.podspec                 # 保留，路径更新
  tobias/
    Package.swift                # 新增
    Sources/
      tobias/
        TobiasPlugin.m
        include/
          tobias/
            TobiasPlugin.h       # 保持 <tobias/TobiasPlugin.h> 可用
        Resources/
          PrivacyInfo.xcprivacy
          AlipaySDK.bundle
    AlipaySDK.xcframework
```

要点：

- 头文件放在 `include/tobias/` 下，`GeneratedPluginRegistrant` 的 `#import <tobias/TobiasPlugin.h>` 在两种方式下都能命中。
- 用 `git mv` 移动，保留文件历史。
- podspec 同步更新：`source_files = 'tobias/Sources/tobias/**/*.{h,m}'`、`public_header_files = 'tobias/Sources/tobias/include/**/*.h'`、`vendored_frameworks`、`resource`、`resource_bundles` 路径全部加 `tobias/` 前缀。
- 更新 `.gitignore` / `.pubignore`，忽略 `.build/`、`.swiftpm/`。

验收：此阶段不引入任何 SPM 行为，CocoaPods 路径必须与阶段 1 表现完全一致。

---

## 阶段 3：编写 Package.swift（0.5 天）

```swift
// swift-tools-version: 5.9
```

- `name: "tobias"`，`platforms: [.iOS(.v13)]`，`products: [.library(name: "tobias", targets: ["tobias"])]`
- `.target(name: "tobias")`
  - `dependencies: ["AlipaySDK"]`
  - `resources`：`.copy("Resources/PrivacyInfo.xcprivacy")`、`.copy("Resources/AlipaySDK.bundle")`
  - `linkerSettings`：`SystemConfiguration`、`CoreTelephony`、`QuartzCore`、`CoreText`、`CoreGraphics`、`UIKit`、`Foundation`、`Network`、`CoreMotion`、`WebKit`，加 `.linkedLibrary("z")`、`.linkedLibrary("c++")`，`-ObjC` 视阶段 0 结论决定
- `.binaryTarget(name: "AlipaySDK", path: "AlipaySDK.xcframework")`
- 不声明 Flutter 依赖：SPM 插件通过 `.library` 暴露，由生成的 `FlutterGeneratedPluginSwiftPackage` 注入。

podspec 中这些配置在 SPM 下无需对应项：`static_framework`、`DEFINES_MODULE`、`EXCLUDED_ARCHS[i386]`、`requires_arc`。

**隐私清单注意**：CocoaPods 下 bundle 名为 `tobias_privacy`，SPM 下变为 `tobias_tobias`。两者都是合法位置，但需在提审时各验证一次。

---

## 阶段 4：移除 tobias_setup.rb（0.5 天）

- 删除 `ios/tobias_setup.rb`，清空 podspec 顶部剩余的 Ruby 逻辑（`YAML.load_file`、`system(...)`、`abort(...)`）。经过阶段 1 与本阶段，podspec 变成一个纯静态文件。
- 正面副作用：不再需要 `xcodeproj`、`plist` 两个 gem，`pod install` 更快、报错面更小。
- 负面副作用：升级用户的 URL Scheme / ATS / 关联域名不再被自动写入。
- README / README_CN 新增「iOS 手动配置」章节，逐项说明：
  - `Info.plist` 的 `CFBundleURLTypes`（填自己的 url scheme）
  - `Info.plist` 的 `LSApplicationQueriesSchemes` 加入 `alipays`
  - `NSAppTransportSecurity` 的 `NSAllowsArbitraryLoads` / `NSAllowsArbitraryLoadsInWebContent`
  - `Runner.entitlements` 的 `com.apple.developer.associated-domains` 填 `applinks:<universal link host>`
  - 说明 `pubspec.yaml` 中 `tobias.url_scheme`、`ios.ignore_security`、`ios.universal_link`、`no_utdid` 全部废弃
- example 工程的 `Info.plist`、`Runner.entitlements` 补齐上述配置并提交（此前由脚本生成，未入库）。

---

## 阶段 5：example 与验证（1 天）

- `flutter config --enable-swift-package-manager`，在 example 中运行，提交 Xcode 自动写入的 `project.pbxproj` 变更。
- 保留 `example/ios/Podfile`，以便切回 CocoaPods 回归测试。
- 测试矩阵（每格都要跑通"编译 + 拉起支付宝 + 回调返回 App"）：

| 场景 | 模拟器 | 真机 |
|---|---|---|
| SPM | ☐ | ☐ |
| CocoaPods | ☐ | ☐ |

- 额外验证：`flutter build ipa` 归档产物中 xcframework 正确嵌入且未重复；隐私清单存在于最终 App；UISceneDelegate 路径（6.0 新增）在 SPM 下仍正常。

---

## 阶段 6：CI 与发布（0.5 天）

- 更新 `.github/workflows`：iOS job 拆成 SPM 与 CocoaPods 两条，分别 `flutter build ios --no-codesign`。
- CHANGELOG 写 `6.0.0-preview.3`，必须包含：
  - 新增 Swift Package Manager 支持
  - **Breaking**：移除 NoUtdid 版本
  - **Breaking**：移除自动工程配置脚本，iOS 需手动配置 Info.plist 与 entitlements
- `flutter pub publish --dry-run` 检查文件清单与体积（删掉 NoUtdid 后约 8MB）。
- 先发 preview 版本，在 issue 中征集验证反馈，稳定后再发正式版。

---

## 里程碑

| 阶段 | 内容 | 预估 |
|---|---|---|
| 0 | 可行性验证 | 0.5 天 |
| 1 | 删除 NoUtdid | 0.5 天 |
| 2 | 目录重构 | 0.5 天 |
| 3 | Package.swift | 0.5 天 |
| 4 | 移除 setup.rb + 文档 | 0.5 天 |
| 5 | example 与测试矩阵 | 1 天 |
| 6 | CI 与发布 | 0.5 天 |

合计约 4 个工作日，主要不确定性在阶段 0 与阶段 5 的资源加载验证。

---

## 回滚策略

全程在 `spm` 分支进行。阶段 1、2 影响 CocoaPods 用户，两个阶段各自单独验收后再往下走。若阶段 3/5 发现 SPM 不可行，删除 `ios/tobias/Package.swift` 即可退回纯 CocoaPods 状态——目录重构与 NoUtdid 下线本身与 SPM 无关，可独立保留。
