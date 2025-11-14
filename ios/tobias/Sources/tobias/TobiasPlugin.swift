import Flutter
import UIKit
import AlipaySDK

@objc public class TobiasPlugin: NSObject, FlutterPlugin, FlutterApplicationLifeCycleDelegate {
    private static weak var instance: TobiasPlugin?
    private var callback: FlutterResult?
    
    public override init() {
        super.init()
        TobiasPlugin.instance = self
    }
    

    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.jarvanmo/tobias",
            binaryMessenger: registrar.messenger()
        )
        let instance = TobiasPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "pay":
            pay(call: call, result: result)
        case "registerApp":
            registerApp(call: call, result: result)
        case "version":
            getVersion(call: call, result: result)
        case "auth":
            auth(call: call, result: result)
        case "isAliPayInstalled":
            isAliPayInstalled(call: call, result: result)
        case "isAliPayHKInstalled":
            isAliPayHKInstalled(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
        
    @objc public func application(
        _ application: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return handleOpenURL(url: url)
    }
    
    @objc public func application(
        _ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any
    ) -> Bool {
        return handleOpenURL(url: url)
    }
    
    public func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([Any]) -> Void
    ) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            AlipaySDK.defaultService().handleOpenUniversalLink(userActivity) { (resultDic) in
                // Handle universal link callback if needed
            }
        }
        return false
    }
    
    // MARK: - Static URL Handler
    
    @objc public static func handleOpenURL(url: URL) -> Bool {
        guard let instance = instance else {
            return false
        }
        return instance.handleOpenURL(url: url)
    }
    
    // MARK: - Private Methods
    
    private func handleOpenURL(url: URL) -> Bool {
        guard url.host == "safepay" else {
            return false
        }
        
        AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { [weak self] (resultDic) in
            self?.onPayResultReceived(resultDic: resultDic)
        })
        
        AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { [weak self] (resultDic) in
            self?.onAuthResultReceived(resultDic: resultDic)
        })
        
        return true
    }
    
    private func onPayResultReceived(resultDic: [AnyHashable: Any]?) {
        guard let callback = callback else {
            return
        }
        
        guard let resultDic = resultDic else {
            self.callback = nil
            return
        }
        
        var mutableDictionary: [String: Any] = [:]
        for (key, value) in resultDic {
            if let stringKey = key as? String {
                mutableDictionary[stringKey] = value
            } else {
                mutableDictionary[String(describing: key)] = value
            }
        }
        mutableDictionary["platform"] = "iOS"
        callback(mutableDictionary)
        self.callback = nil
    }
    
    private func onAuthResultReceived(resultDic: [AnyHashable: Any]?) {
        guard let callback = callback else {
            return
        }
        
        guard let resultDic = resultDic else {
            self.callback = nil
            return
        }
        
        var mutableDictionary: [String: Any] = [:]
        for (key, value) in resultDic {
            if let stringKey = key as? String {
                mutableDictionary[stringKey] = value
            } else {
                mutableDictionary[String(describing: key)] = value
            }
        }
        mutableDictionary["platform"] = "iOS"
        callback(mutableDictionary)
        self.callback = nil
    }
    
    private func pay(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let urlScheme = fetchUrlScheme() else {
            result(FlutterError(
                code: "AliPay UrlScheme Not Found",
                message: "Config AliPay First",
                details: nil
            ))
            return
        }
        
        pay(call: call, result: result, urlScheme: urlScheme)
    }
    
    private func pay(call: FlutterMethodCall, result: @escaping FlutterResult, urlScheme: String) {
        self.callback = result
        
        guard let arguments = call.arguments as? [String: Any],
              let order = arguments["order"] as? String else {
            result(FlutterError(
                code: "InvalidArguments",
                message: "Order string is required",
                details: nil
            ))
            self.callback = nil
            return
        }
        
        let universalLink = arguments["universalLink"] as? String
        
        AlipaySDK.defaultService().payOrder(
            order,
            fromScheme: urlScheme,
            fromUniversalLink: universalLink
        ) { [weak self] (resultDic) in
            self?.onPayResultReceived(resultDic: resultDic)
        }
    }
    
    private func auth(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let urlScheme = fetchUrlScheme() else {
            result(FlutterError(
                code: "AliPay UrlScheme Not Found",
                message: "Config AliPay First",
                details: nil
            ))
            return
        }
        
        self.callback = result
        
        
        
        guard let arguments = call.arguments as? String else {
            result(FlutterError(
                code: "InvalidArguments",
                message: "Auth info is required",
                details: nil
            ))
            self.callback = nil
            return
        }
        AlipaySDK.defaultService().auth_V2(
            withInfo: arguments,
            fromScheme: urlScheme
        ) { [weak self] (resultDic) in
            self?.onAuthResultReceived(resultDic: resultDic)
        }
    }
    
    private func getVersion(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let version = AlipaySDK.defaultService().currentVersion
        result(version)
    }
    
    private func registerApp(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let appId = arguments["appId"] as? String else {
            result(FlutterError(
                code: "InvalidArguments",
                message: "App ID is required",
                details: nil
            ))
            return
        }
        
        let universalLink = arguments["universalLink"] as? String
        AlipaySDK.defaultService().registerApp(appId, universalLink: universalLink)
        result(nil)
    }
    
    private func fetchUrlScheme() -> String? {
        guard let infoDic = Bundle.main.infoDictionary,
              let types = infoDic["CFBundleURLTypes"] as? [[String: Any]] else {
            return nil
        }
        
        for dic in types {
            if let urlName = dic["CFBundleURLName"] as? String,
               urlName == "alipay",
               let schemes = dic["CFBundleURLSchemes"] as? [String],
               let firstScheme = schemes.first {
                return firstScheme
            }
        }
        
        return nil
    }
    
    private func isAliPayInstalled(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let alipaysURL = URL(string: "alipays://"),
              let alipayURL = URL(string: "alipay://") else {
            result(false)
            return
        }
        
        let canOpenAlipays = UIApplication.shared.canOpenURL(alipaysURL)
        let canOpenAlipay = UIApplication.shared.canOpenURL(alipayURL)
        result(canOpenAlipays || canOpenAlipay)
    }
    
    private func isAliPayHKInstalled(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let alipayhkURL = URL(string: "alipayhk://") else {
            result(false)
            return
        }
        
        let canOpen = UIApplication.shared.canOpenURL(alipayhkURL)
        result(canOpen)
    }
}

