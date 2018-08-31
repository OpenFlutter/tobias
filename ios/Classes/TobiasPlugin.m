#import "TobiasPlugin.h""

@implementation TobiasPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.jarvanmo/tobias"
            binaryMessenger:[registrar messenger]];
  TobiasPlugin* instance = [[TobiasPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

+(void)handlePayment:(NSURL *)url{
  
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"pay" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

-(void) pay:(FlutterMethodCall*)call result:(FlutterResult)result{

}


@end
