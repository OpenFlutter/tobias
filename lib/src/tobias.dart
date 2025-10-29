import 'config.dart';
import 'tobias_platform_interface.dart';

class Tobias {
  /// Register the merchant appId before payment. Alipay uses this mainly for anti-fraud
  /// measures to improve payment security, and it can noticeably optimize the payment
  /// experience (faster invocation of payment and a positive effect on success rate).
  /// Note: Considering merchant migration costs, this interface is not mandatory right now.
  /// If it is not called the payment flow will not be affected, but appId-based anti-fraud
  /// security features and related experience optimizations will not take effect.
  /// []universalLink] only supports iOS
  Future<void> registerApp(String appId,{String? universalLink}) async {
    return await TobiasPlatform.instance.registerApp(appId,universalLink: universalLink);
  }

  /// [evn] only supports Android due to native AliPaySDK
  /// [universalLink] only supports iOS
  /// [showPayLoading] controls if there is loading while paying, only supports Android and OpenHarmony.
  Future<Map> pay(String order,
      {AliPayEvn evn = AliPayEvn.online,
      bool showPayLoading = true,
      String? universalLink}) async {
    return await TobiasPlatform.instance
        .pay(order, evn: evn, universalLink: universalLink);
  }

  /// 鸿蒙 - 自动订阅支付
  Future<Map> payOhosAutoSub(String order) async {
    return await TobiasPlatform.instance.payOhosAutoSub(order);
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
