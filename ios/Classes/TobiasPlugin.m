#import "TobiasPlugin.h"
#import <AlipaySDK/AlipaySDK.h>

__weak TobiasPlugin* __tobiasPlugin;

@interface TobiasPlugin()

@property (readwrite,copy,nonatomic) FlutterResult callback;

@end



@implementation TobiasPlugin

-(id)init{
    if(self = [super init]){
        
        __tobiasPlugin  = self;
        
    }
    return self;
}

-(void)dealloc{
    
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.jarvanmo/tobias"
            binaryMessenger:[registrar messenger]];
  TobiasPlugin* instance = [[TobiasPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  [registrar addApplicationDelegate:instance];
}




- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"pay" isEqualToString:call.method]) {
      [self pay:call result:result];
  } else if([@"version" isEqualToString:call.method]){
      [self getVersion:call result:result];
  } else if([@"auth" isEqualToString:call.method]){
      [self _auth:call result:result];
  } else if([@"isAliPayInstalled" isEqualToString:call.method]){
      [self  _isAliPayInstalled:call result:result];
  }else{
      result(FlutterMethodNotImplemented);
  }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    return [self handleOpenURL:url];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
    return [self handleOpenURL:url];
}


+(BOOL)handleOpenURL:(NSURL*)url{
  
    if(!__tobiasPlugin)return NO;
    return [__tobiasPlugin handleOpenURL:url];
    
}


-(BOOL)handleOpenURL:(NSURL*)url{
    
    if ([url.host isEqualToString:@"safepay"]) {

        __weak TobiasPlugin* __self = self;

        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
             [__self onPayResultReceived:resultDic];
        }];

        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
             [__self onAuthResultReceived:resultDic];
         }];

        return YES;
    }
    return NO;
}

-(void)onPayResultReceived:(NSDictionary*)resultDic{

    if(self.callback!=nil){
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:resultDic];
        [mutableDictionary setValue:@"iOS" forKey:@"platform"];
        self.callback(mutableDictionary);
        self.callback = nil;
    }
    
}

-(void)onAuthResultReceived:(NSDictionary*)resultDic{

    if(self.callback!=nil){
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:resultDic];
        [mutableDictionary setValue:@"iOS" forKey:@"platform"];
        self.callback(mutableDictionary);
        self.callback = nil;
    }

}

-(void) pay:(FlutterMethodCall*)call result:(FlutterResult)result{

    NSString* urlScheme = [self fetchUrlScheme];
    if(!urlScheme){
        result([FlutterError errorWithCode:@"AliPay UrlScheme Not Found" message:@"Config AliPay First" details:nil]);
        return;
    }

 
    [self _pay:call result:result urlScheme:urlScheme];

}

-(void) _pay:(FlutterMethodCall*)call result:(FlutterResult)result urlScheme:(NSString *)urlScheme{
    self.callback = result;
    
    __weak TobiasPlugin* __self = self;

    [[AlipaySDK defaultService] payOrder:call.arguments[@"order"] fromScheme:urlScheme callback:^(NSDictionary *resultDic) {
        [__self onPayResultReceived:resultDic];
    }];

}

-(void) _auth:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString* urlScheme = [self fetchUrlScheme];
    if(!urlScheme){
        result([FlutterError errorWithCode:@"AliPay UrlScheme Not Found" message:@"Config AliPay First" details:nil]);
        return;
    }
    self.callback = result;
    
    __weak TobiasPlugin* __self = self;
    
  [[AlipaySDK defaultService] auth_V2WithInfo:call.arguments
                                         fromScheme:urlScheme
                                           callback:^(NSDictionary *resultDic) {
                                               [__self onAuthResultReceived:resultDic];
                                           }];
}

-(void) getVersion:(FlutterMethodCall*)call result:(FlutterResult)result{

    NSString *version = [AlipaySDK defaultService].currentVersion;
    if(version == nil){
        version = @"";
    }
    result(version);
}

-(NSString*)fetchUrlScheme{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSArray* types = infoDic[@"CFBundleURLTypes"];
    for(NSDictionary* dic in types){
        if([@"alipay" isEqualToString:dic[@"CFBundleURLName"]]){
            return dic[@"CFBundleURLSchemes"][0];
        }
    }
    return nil;
}

-(void) _isAliPayInstalled:(FlutterMethodCall*)call result:(FlutterResult)result {
   BOOL isAliPayInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipays://"]]||[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]];
   result(@(isAliPayInstalled));
}

@end
