import 'package:flutter/services.dart';
import 'alipay_model.dart';
import 'dart:async';

final MethodChannel _channel = const MethodChannel('com.jarvanmo/tobias');

Future pay(AliPayModel model) async{
  return await _channel.invokeMethod("pay");
}

Future<String> version() async {
  return await _channel.invokeMethod("version");
}