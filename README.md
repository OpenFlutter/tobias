![logo](./arts/tobias_logo.png)
![Build status](https://github.com/OpenFlutter/tobias/actions/workflows/build_test.yml/badge.svg)

[中文移步这里](./README_CN.md)

> Join QQ Group now: 1003811176

![QQGroup](https://gitee.com/OpenFlutter/resoures-repository/raw/master/common/flutter.png)

## What's Tobias

Tobias is a  flutter plugin for AliPaySDK.

## Getting Started

I highly recommend that you read  [the official documents](https://docs.open.alipay.com/204/105051/) before using tobias.

1. You have to config `url_scheme` in [pubspec.yaml](./example/pubspec.yaml). Url scheme is a unique string to 
resume you app on iOS but please note that `_` is invalid.

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
 
> If you're facing conflicts with `utdid` on iOS, you can set `no_utdid: true` in [pubspec.yaml](./example/pubspec.yaml)
  
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
