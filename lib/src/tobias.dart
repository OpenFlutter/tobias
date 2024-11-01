import 'config.dart';
import 'tobias_platform_interface.dart';

class Tobias {
  /// [evn] only supports Android due to native AliPaySDK
  /// [universalLink] only supports iOS
  Future<Map> pay(String order,
      {AliPayEvn evn = AliPayEvn.online,
      String? universalLink,
      bool isOhosAutoSub = false}) async {
    return await TobiasPlatform.instance
        .pay(order, evn: evn, universalLink: universalLink);
  }

  /// Auth by AliPay
  Future<Map> auth(String auth) async {
    return await TobiasPlatform.instance.auth(auth);
  }

  /// AliPay version
  Future<String> get aliPayVersion async {
    return await TobiasPlatform.instance.aliPayVersion;
  }

  /// If the user has installed AliPay
  Future<bool> get isAliPayInstalled async {
    return await TobiasPlatform.instance.isAliPayInstalled;
  }

  /// If the user has installed AliPayHk
  Future<bool> get isAliPayHKInstalled async {
    return await TobiasPlatform.instance.isAliPayHKInstalled;
  }
}
