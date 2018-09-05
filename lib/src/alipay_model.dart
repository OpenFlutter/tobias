import 'package:flutter/foundation.dart';

///a data container for payment
///[appId] the id you applied on AliPay

class AliPayModel {
  final String appId;
  final String bizContent;
  final String charset;
  final String method;
  final String timestamp;
  final bool isRSA2;
  final String version;
  final String sign;

  AliPayModel(
      {@required this.appId,
      @required this.sign,
      this.bizContent: "alipay sdk powered by tobias",
      this.charset: "utf-8",
      this.method: "alipay.trade.app.pay",
      this.timestamp,
      this.isRSA2: true,
      this.version: "1.0"})
      : assert(appId != null && appId.isNotEmpty);

  String order() {
    String realTimestamp = timestamp;
    if (realTimestamp == null || realTimestamp.trim().isEmpty) {}

    String signType = isRSA2 ? "RSA2" : "RSA";
    return "app_id=$appId"
        "&biz_content=$bizContent"
        "&charset=$charset"
        "&method=$method"
        "&timestamp=$realTimestamp"
        "&sign_type=$signType"
        "&version=$version"
        "&sign=$sign";
  }
}
