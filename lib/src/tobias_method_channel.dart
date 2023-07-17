import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'config.dart';
import 'tobias_platform_interface.dart';

/// An implementation of [TobiasPlatform] that uses method channels.
class MethodChannelTobias extends TobiasPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.jarvanmo/tobias');

  /// [evn] only supports Android due to native AliPaySDK
  @override
  Future<Map> pay(String order, {AliPayEvn evn = AliPayEvn.online}) async {
    return await methodChannel
        .invokeMethod("pay", {"order": order, "payEnv": evn.index});
  }

  /// Auth by AliPay
  @override
  Future<Map> auth(String auth) async {
    return await methodChannel.invokeMethod("auth", auth);
  }

  /// AliPay version
  @override
  Future<String> get aliPayVersion async {
    return await methodChannel.invokeMethod("version");
  }

  /// If the user has installed AliPay
  @override
  Future<bool> get isAliPayInstalled async {
    return await methodChannel.invokeMethod("isAliPayInstalled");
  }

  /// If the user has installed AliPayHk
  @override
  Future<bool> get isAliPayHKInstalled async {
    return await methodChannel.invokeMethod("isAliPayHKInstalled");
  }
}
