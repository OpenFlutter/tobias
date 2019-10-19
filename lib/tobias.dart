import 'dart:async';
import 'package:flutter/services.dart';

final MethodChannel _channel = const MethodChannel('com.jarvanmo/tobias');

/// [evn] only supports Android due to native AliPaySDK
@Deprecated("replace with aliPay(String, AliPayEnv)")
Future<Map> pay(String order, {AliPayEvn evn = AliPayEvn.ONLINE}) async {
  return await _channel
      .invokeMethod("pay", {"order": order, "payEnv": evn.index});
}

@Deprecated("replace with aliPayAuth(String) ")
Future<Map> auth(String auth) async {
  return await _channel.invokeMethod("auth", auth);
}

@Deprecated("replace with aliPayVersion() ")
Future<String> version() async {
  return await _channel.invokeMethod("version");
}

/// [evn] only supports Android due to native AliPaySDK
Future<Map> aliPay(String order, {AliPayEvn evn = AliPayEvn.ONLINE}) async {
  return await _channel
      .invokeMethod("pay", {"order": order, "payEnv": evn.index});
}

Future<Map> aliPayAuth(String auth) async {
  return await _channel.invokeMethod("auth", auth);
}

Future<String> aliPayVersion() async {
  return await _channel.invokeMethod("version");
}

Future<bool> isAliPayInstalled() async {
  return await _channel.invokeMethod("isAliPayInstalled");
}

enum AliPayEvn { ONLINE, SANDBOX }
