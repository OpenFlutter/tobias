![logo](./arts/tobias_logo.png)
![pub package](https://img.shields.io/pub/v/tobias.svg)

QQ 群：892398530。

## Tobias是什么

Tobias是一个为支付宝支付SDK做的Flutter插件。

## 开始

在使用前强烈阅读[官方接入指南](https://docs.open.alipay.com/204/105051/)。
Tobias 可以完成一部分但不是全部工作。
例如，在iOS上你还要设置URL Scheme。





## 支付
Tobias使用起来很简单，只需要把从服务器取得的字符串交给Tobias就行了:
```dart
import 'package:tobias/tobias.dart' as tobias;
tobias.pay(yourOrder);
```

## 授权登录

```
    tobias.auth("your auth str");

```



## 检查支付宝安装情况

```
    var result = await tobias.isAliPayInstalled();
   
```   
   
返回值是一个包含支付宝支付结果的`map`。其中还包含了一个额外的 `platform`字段，
它的值为 `iOS` 或 `android`。
> 注意:Tobias 使用的是 pay_V2.

在 iOS中还要添加一个名为`alipay`的URL Schema。
通过GUI添加:
![url_schema](./arts/url_schema.png)


在`info.plist`文件中添加:
```
<array>
   		<dict>
   			<key>CFBundleTypeRole</key>
   			<string>Editor</string>
   			<key>CFBundleURLName</key>
   			<string>alipay</string>
   			<key>CFBundleURLSchemes</key>
   			<array>
   				<string>tobiasexample</string>
   			</array>
   		</dict>
   	</array>

```

你可以通过调用 `tobias.version()` 来获取对应平上的SDK版本，其返回值是一个包含 `version` 和 `platform`的map。
结果示例:
```dart
{
result: partner="2088411752388544"&seller_id="etongka123@163.com"&out_trade_no="180926084213001"&subject="test pay"&total_fee="0.01"&notify_url="http://127.0.0.1/alipay001"&service="mobile.securitypay.pay"&payment_type="1"&_input_charset="utf-8"&it_b_pay="30m"&return_url="m.alipay.com"&success="true"&sign_type="RSA"&sign="nCZ8MDhsNvYNAbrLZJZ2VUy6vydgAp+JCq1aQo6ORDYtI9zwtnja3qNGQNiDJCuktoIj7fSTM487XhjPDqnOreZjIA1GJpxu9D1I3nMXIn1M7DfZ0noDwXcYZ438/jbYac7g8mhpwdKGweLCAni9mO3Y6q3iBFkox8i9PcsGxJY=",
resultStatus: 9000,
 memo: ,
 platform:iOS
}

```

## 升级到1.0.0

从`tobais 1.0.0`开始开发者不必重写`AppDelegate`了。如果你以前重写了这个方法,请在 `AppDelegate`中删除相应的代码:

```objective-c

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
  return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}
```

如果一定要重写这2个方法,请确保你调用了 `super`:
```objective-c

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
  return [super application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
  return [super application:application openURL:url options:options];
}
```

## 请作者喝杯咖啡。

<img src="./arts/wx.jpeg" height="300">  <img src="./arts/ali.jpeg" height="300">

### 欢迎关注公众号
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
