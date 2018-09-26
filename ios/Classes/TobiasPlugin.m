#import "TobiasPlugin.h"


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
}




- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"pay" isEqualToString:call.method]) {
      [self pay:call result:result];
  } else if([@"version" isEqualToString:call.method]){
      [self getVersion:call result:result];
  } else{
      result(FlutterMethodNotImplemented);
  }
}

+(BOOL)handleOpenURL:(NSURL*)url{
  
    if(!__tobiasPlugin)return NO;
    return [__tobiasPlugin handleOpenURL:url];
    
}


-(BOOL)handleOpenURL:(NSURL*)url{
    
    if ([url.host isEqualToString:@"safepay"]) {

        __weak TobiasPlugin* __self = self;
        
     
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
             [__self onResultReceived:resultDic];
        }];
        

        return YES;
    }
    return NO;
}

-(void)onResultReceived:(NSDictionary*)resultDic{

    if(self.callback!=nil){
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:resultDic];
        [mutableDictionary setValue:@"platform" forKey:@"iOS"];
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
//    [[AlipaySDK defaultService] auth_V2WithInfo:call.arguments
//                                     fromScheme:urlScheme
//                                       callback:^(NSDictionary *resultDic) {
//
//                                           NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:resultDic];
//                                           [mutableDictionary setValue:@"platform" forKey:@"iOS"];
//
//                                           result(mutableDictionary);
//                                       }];

    [[AlipaySDK defaultService] payOrder:call.arguments fromScheme:urlScheme callback:^(NSDictionary *resultDic) {
//        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:resultDic];
//        [mutableDictionary setValue:@"platform" forKey:@"iOS"];
//        
//        result(mutableDictionary);
    }];

}

-(void) getVersion:(FlutterMethodCall*)call result:(FlutterResult)result{

    NSString *version = [AlipaySDK defaultService].currentVersion;
    if(version == nil){
        version = @"";
    }
    result(@{

            @"platform" :@"iOS",
            @"version" : version
    });
}

-(NSString*)fetchUrlScheme{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSArray* types = [infoDic objectForKey:@"CFBundleURLTypes"];
    for(NSDictionary* dic in types){
        if([@"alipay" isEqualToString: [dic objectForKey:@"CFBundleURLName"]]){
            return [dic objectForKey:@"CFBundleURLSchemes"][0];
        }
    }
    return nil;
}


@end
