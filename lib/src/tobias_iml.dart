import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

final MethodChannel _channel = const MethodChannel('com.jarvanmo/tobias');

/// [evn] only supports Android due to native AliPaySDK
Future<Map> pay(String order,{AliPayEvn evn = AliPayEvn.ONLINE}) async {
  return await _channel.invokeMethod("pay", {
    "order":order,
    "payEnv":evn.index
  });
}




Future<Map> auth(String auth) async {
  return await _channel.invokeMethod("auth", auth);
}

Future<String> version() async {
  return await _channel.invokeMethod("version");
}


enum AliPayEvn{
  ONLINE,
  SANDBOX
}