![logo](./arts/tobias_logo.png)
![pub package](https://img.shields.io/pub/v/tobias.svg)

[中文移步这里](./README_CN.md)

## What's Tobias

Tobias is a  flutter plugin for AliPaySDK.

## Getting Started

I highly recommend that you read this [article](https://docs.open.alipay.com/204/105051/) before using tobias.
Tobias helps you to do something but not all.
For example, you have to configure your URL Scheme on iOS.

## Libraries Used In Tobias

We'd better know what tobias used.
For Android:
```gradle
    implementation 'org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.3.0'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-core:1.0.0'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:1.0.0'
```
Tobias uses *alipaySdk-15.5.7-20181023110917.aar* in Android.
For iOS:
```ruby
  s.dependency 'OpenAliPaySDK', '~> 15.5.7'
```


## Usage
It's simple,pass Tobias your order info from server :
```dart
import 'package:tobias/tobias.dart' as tobias;
tobias.pay(yourOrder);
```
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
In order to handle the result of payment, you have to add the following code in your `AppDelegate.m` file:
```objective-c
#import <tobias/TobiasPlugin.h>

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{

    return  [TobiasPlugin handleOpenURL:url];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{

    return  [TobiasPlugin handleOpenURL:url];
}

```
> NOTE:Tobias use pay_V2.

For iOS,yout have to add url schema named `alipay`.
On Xcode GUI:
![url_schema](./arts/url_schema.png)


in your `info.plist`:
```
     <array>
   		<dict>
   			<key>CFBundleTypeRole</key>
   			<string>Editor</string>
   			<key>CFBundleURLName</key>
   			<string>alipay</string>
   			<key>CFBundleURLSchemes</key>
   			<array>
   				<string>tobias_example</string>
   			</array>
   		</dict>
   	</array>

```

You can also call `tobias.version()` which returns a map contains `version` and `platform`.

### Donate
Buy the writer a cup of coffee。

<img src="./arts/wx.jpeg" height="300">  <img src="./arts/ali.jpeg" height="300">

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
