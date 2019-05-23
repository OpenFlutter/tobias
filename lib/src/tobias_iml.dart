import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

final MethodChannel _channel = const MethodChannel('com.jarvanmo/tobias');

Future<Map> pay(String order) async {
  return await _channel.invokeMethod("pay", order);
}

Future<Map> payInSandBox(String order) async {
  if(Platform.isAndroid){
    return await _channel.invokeMethod("pay_in_sand_box", order);
  }
  return pay(order);
}


Future<Map> auth(String auth) async {
  return await _channel.invokeMethod("auth", auth);
}

Future<String> version() async {
  return await _channel.invokeMethod("version");
}
