![logo](./arts/tobias_logo.png)

## Tobias是什么
Tobias是一个为支付宝支付SDK做的Flutter插件。

## Getting Started
在使用前强烈阅读[官方接入指南](https://docs.open.alipay.com/204/105051/)。
Tobias 可以完成一部分但不是全部工作。
例如，在iOS上你还要设置URL Scheme。

## Tobias所依赖的库
很有必要知道Tobias使用到了哪些技术。
Android上:
```gradle
    api files('libs/alipaySdk-20180601.jar')
    implementation 'org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.2.60'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-core:0.24.0'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:0.24.0'
```
iOS上:
```ruby
  s.dependency 'OpenAliPaySDK', '~> 15.5'
```

## 将Tobias 添加至 `pubspec.yaml`
将下面的代码添加到 `pubspec.yaml`:
```yaml
dependencies:
  tobias: ^0.0.1
```
## 如何使用
Tobias使用起来很简单.Tobias提供了两种方式:
```dart
import 'package:tobias/tobias.dart' as tobias;
tobias.payWithOrder(yourOrder);
tobias.pay(tobias.AliPayModel(appId: "appId",sign: "sign"));
```
返回值是一个包含支付宝支付结果的`map`。其中还包含了一个额外的 `platform`字段，
它的值为 `iOS` 或 `android`。
> 注意:Tobias 使用的是 pay_V2.

你可以通过调用 `tobias.version()` 来获取对应平上的SDK版本，其返回值是一个包含 `version` 和 `platform`的map。
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
