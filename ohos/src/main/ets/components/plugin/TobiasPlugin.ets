import {
  AbilityAware,
  AbilityPluginBinding,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import { bundleManager, common } from '@kit.AbilityKit';
import * as alipay from "@cashier_alipay/cashiersdk"
import { BusinessError } from '@kit.BasicServicesKit';

const MESSAGE_CHANNEL_NAME = "com.jarvanmo/tobias";

/** TobiasPlugin **/
export default class TobiasPlugin implements FlutterPlugin, MethodCallHandler, AbilityAware {
  private channel: MethodChannel | null = null;
  private context: common.UIAbilityContext | null = null;

  getUniqueClassName(): string {
    return "TobiasPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), MESSAGE_CHANNEL_NAME);
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.channel?.setMethodCallHandler(null)
    this.channel = null
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    this.context = binding.getAbility().context;
  }

  onDetachedFromAbility(): void {
    this.context = null;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case "version":
        this.version(result);
        break;
      case "pay":
        this.pay(call, result);
        break;
      case "auth":
        result.notImplemented();
        break;
      case "isAliPayInstalled":
        this.isAliPayInstalled(result);
        break;
      case "isAliPayHKInstalled":
        this.isAliPayHKInstalled(result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  version(result: MethodResult): void {
    const pay = new alipay.Pay();
    result.success(pay.getVersion());
  }

  pay(call: MethodCall, result: MethodResult): void {
    const order: string = call.argument("order");
    const isShowLoading: boolean = true;
    const payment = new alipay.Pay();
    payment.pay(order, isShowLoading)
      .then((res: Map<string, string>) => {
        result.success(res);
      })
      .catch((_: BusinessError) => {
        const resp: Map<string, string> = new Map();
        resp.set("resultStatus", "-1");
        result.success(resp);
      });
  }

  isAliPayInstalled(result: MethodResult): void {
    result.success(bundleManager.canOpenLink("alipays://"))
  }

  isAliPayHKInstalled(result: MethodResult): void {
    result.success(bundleManager.canOpenLink("alipayhk://"))
  }
}