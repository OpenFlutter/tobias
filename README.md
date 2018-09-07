![logo](./arts/tobias_logo.png)


[中文移步这里](./README_CN.md)
## What's Tobias
Tobias is flutter plugin for AliPaySDK.

## Getting Started
I highly recommend that you read this [article](https://docs.open.alipay.com/204/105051/) before using tobias.
Tobias helps you to do something but not all.
For example, you have to configure your URL Scheme on iOS.

## Libraries Used In Tobias
We'd better know what tobias used.
For Android:
```gradle
    api files('libs/alipaySdk-20180601.jar')
    implementation 'org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.2.60'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-core:0.24.0'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:0.24.0'
```
For iOS:
```ruby
  s.dependency 'OpenAliPaySDK', '~> 15.5'
```

## Add Tobias To `pubspec.yaml`
Add these following code in your `pubspec.yaml`:
```yaml
dependencies:
  tobias: ^0.0.2
```
## How To Use
It's every easy.Tobias provides two ways if you want a payment:
```dart
import 'package:tobias/tobias.dart' as tobias;
tobias.payWithOrder(yourOrder);
tobias.pay(tobias.AliPayModel(appId: "appId",sign: "sign"));
```
The result is map contains results from AliPay.The result also contains an external filed named `platform` which
means the result is from `iOS` or `android`.
> NOTE:Tobias use pay_V2.

On iOS, add url schema name `alipay`.
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
