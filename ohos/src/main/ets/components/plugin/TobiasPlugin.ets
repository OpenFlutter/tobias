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
import OpenLinkOptions from '@ohos.app.ability.OpenLinkOptions';

const MESSAGE_CHANNEL_NAME = "com.jarvanmo/tobias";
const TAG: string = 'TobiasPlugin';

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
      case "payOhosAutoSub":
        this.payOhosAutoSub(call, result);
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
    const isShowLoading: boolean = call.argument("showPayLoading");
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

  payOhosAutoSub(call: MethodCall, result: MethodResult): void {
    const order: string = call.argument("order");
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    let openLinkOptions: OpenLinkOptions = {
      appLinkingOnly: false
    };
    const resp: Map<string, string> = new Map();
    try {  
      context.openLink(order, openLinkOptions)
        .then(() => {
          console.log(TAG, 'open link success.');
          resp.set("resultStatus", "success");
          result.success(resp)
        }).catch((err: BusinessError) => {
        console.log(TAG, `open link failed. Code is ${err.code}, message is ${err.message}`);
        resp.set("resultStatus", "erroe");
        result.success(resp)
      })
    } catch (paramError) {
      console.log(TAG, `Failed to start link. Code is ${paramError.code}, message is ${paramError.message}`);
      resp.set("resultStatus", "erroe");
      result.success(resp)
    }
  }

  isAliPayInstalled(result: MethodResult): void {
    result.success(bundleManager.canOpenLink("alipays://"))
  }

  isAliPayHKInstalled(result: MethodResult): void {
    result.success(bundleManager.canOpenLink("alipayhk://"))
  }
}