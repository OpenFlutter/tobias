![logo](./arts/tobias_logo.png)

[![pub package](https://img.shields.io/pub/v/tobias.svg)](https://pub.dartlang.org/packages/tobias)
![Build status](https://github.com/OpenFlutter/tobias/actions/workflows/build_test.yml/badge.svg)
[![GitHub stars](https://img.shields.io/github/stars/OpenFlutter/tobias)](https://github.com/OpenFlutter/tobias/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/OpenFlutter/tobias)](https://github.com/OpenFlutter/tobias/network)
[![GitHub license](https://img.shields.io/github/license/OpenFlutter/tobias)](https://github.com/OpenFlutter/tobias/blob/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/OpenFlutter/tobias)](https://github.com/OpenFlutter/tobias/issues)
<a target="_blank" href="https://qm.qq.com/q/TJ29rkzywM"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="OpenFlutter" title="OpenFlutter"></a>

[中文移步这里](./README_CN.md)

> Join QQ Group now: 1003811176

![QQGroup](https://gitee.com/OpenFlutter/resoures-repository/raw/master/common/flutter.png)

## What's Tobias

Tobias is a  flutter plugin for AliPaySDK, works on iOS, Android and OpenHarmony

## Getting Started

I highly recommend that you read  [the official documents](https://docs.open.alipay.com/204/105051/) before using tobias.

1. For iOS, you have to configure your Xcode project manually. See [iOS Configuration](#ios-configuration).

2. for OpenHarmony, you have to add scheme `alipays` to module.json5 in your project like this:

```json5
{
  "module": {
    "querySchemes": [
      "alipays"
    ],
  }
}
```

## iOS Configuration

> **Breaking change in 6.0.0**: tobias no longer modifies your Xcode project during `pod install`.
> The `tobias:` section in `pubspec.yaml` (`url_scheme`, `no_utdid`, `ios.ignore_security`,
> `ios.universal_link`) is obsolete and is ignored. Configure the following by hand.

### Swift Package Manager

tobias supports both Swift Package Manager and CocoaPods. To use SPM, enable it once:

```shell
flutter config --enable-swift-package-manager
```

Nothing else is required — Flutter picks up `ios/tobias/Package.swift` automatically. If SPM is
not enabled, the CocoaPods podspec is used as before.

### 1. Info.plist

Add your own url scheme (a unique string used to resume your app, `_` is **not** allowed):

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>alipay</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>your_url_scheme</string>
        </array>
    </dict>
</array>
```

Allow your app to query the Alipay app:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>alipays</string>
</array>
```

Alipay still serves some content over HTTP, so unless you know what you are doing, add:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSAllowsArbitraryLoadsInWebContent</key>
    <true/>
</dict>
```

### 2. Runner.entitlements

Universal link is required by Alipay. Enable the **Associated Domains** capability and add the
host of your universal link:

```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:your.domain.com</string>
</array>
```

See [example/ios/Runner](./example/ios/Runner) for a working setup.

## Payment

It's simple,pass Tobias your order info from server :

```dart
import 'package:tobias/tobias.dart' ;
Tobias tobias = Tobias();
tobias.pay(yourOrder);
```

If you're working with iOS, please add and pass universal link. See [how to configure universal link](https://opendocs.alipay.com/open/0b9qzi).

The result is map contains results from AliPay.The result also contains an external filed named `platform` which
means the result is from `iOS` or `android`.
Result sample:

```dart
{
result: partner="2088411752388544"&seller_id="etongka123@163.com"&out_trade_no="180926084213001"&subject="test pay"&total_fee="0.01"&notify_url="http://127.0.0.1/alipay001"&service="mobile.securitypay.pay"&payment_type="1"&_input_charset="utf-8"&it_b_pay="30m"&return_url="m.alipay.com"&success="true"&sign_type="RSA"&sign="nCZ8MDhsNvYNAbrLZJZ2VUy6vydgAp+JCq1aQo6ORDYtI9zwtnja3qNGQNiDJCuktoIj7fSTM487XhjPDqnOreZjIA1GJpxu9D1I3nMXIn1M7DfZ0noDwXcYZ438/jbYac7g8mhpwdKGweLCAni9mO3Y6q3iBFkox8i9PcsGxJY=",
resultStatus: 9000,
 memo: ,
 platform:iOS
}

```

 > NOTE:Tobias use pay_V2.

> NOTE: the `no_utdid` variant of the iOS SDK has been removed in 6.0.0. If you depend on it,
> stay on 5.x for now.

## Auth

```
import 'package:tobias/tobias.dart' ;
Tobias tobias = Tobias();
tobias.auth("your auth str);
```

## Check AliPay Installation

```
Tobias tobias = Tobias();
var result = await tobias.isAliPayInstalled;
```

You can also call `tobias.version` which returns a map contains `version` and `platform`.

## Upgrade to 1.0.0

There's no need to override `AppDelegate` since `tobais 1.0.0`. If you have done that before, please remove
the following code in your `AppDelegate`:

```objective-c

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [TobiasPlugin handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
  return [TobiasPlugin handleOpenURL:url];
}
```

If you have to override these two functions, make sure you have called the `super`:

```objective-c

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
  return [super application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
  return [super application:application openURL:url options:options];
}
```

### Donate

Buy me a cup of coffee。

<img src="./arts/wx.jpeg" height="300">  <img src="./arts/ali.jpeg" height="300">

### Subscribe Us On WeChat

![subscribe](./arts/wx_subscription.png)

## LICENSE

    Copyright 2018 OpenFlutter Project

    Licensed to the Apache Software Foundation (ASF) under one or more contributor
    license agreements.  See the NOTICE file distributed with this work for
    additional information regarding copyright ownership.  The ASF licenses this
    file to you under the Apache License, Version 2.0 (the "License"); you may not
    use this file except in compliance with the License.  You may obtain a copy of
    the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
    License for the specific language governing permissions and limitations under
    the License.
