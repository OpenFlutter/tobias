import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'config.dart';
import 'tobias_method_channel.dart';

abstract class TobiasPlatform extends PlatformInterface {
  /// Constructs a TobiasPlatform.
  TobiasPlatform() : super(token: _token);

  static final Object _token = Object();

  static TobiasPlatform _instance = MethodChannelTobias();

  /// The default instance of [TobiasPlatform] to use.
  ///
  /// Defaults to [MethodChannelTobias].
  static TobiasPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TobiasPlatform] when
  /// they register themselves.
  static set instance(TobiasPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// [evn] only supports Android due to native AliPaySDK
  Future<Map> pay(String order,
      {AliPayEvn evn = AliPayEvn.online,
      bool showPayLoading = true,
      String? universalLink}) async {
    throw UnimplementedError('pay() has not been implemented.');
  }

  /// 鸿蒙 - 自动订阅支付
  Future<Map> payOhosAutoSub(String order) async {
    throw UnimplementedError('payOhosAutoSub() has not been implemented.');
  }

  Future<Map> auth(String auth) async {
    throw UnimplementedError('auth() has not been implemented.');
  }

  Future<String> get aliPayVersion {
    throw UnimplementedError('aliPayVersion has not been implemented.');
  }

  Future<bool> get isAliPayInstalled {
    throw UnimplementedError('isAliPayInstalled has not been implemented.');
  }

  Future<bool> get isAliPayHKInstalled {
    throw UnimplementedError('isAliPayHKInstalled has not been implemented.');
  }
}
