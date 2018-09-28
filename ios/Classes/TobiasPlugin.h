#import <Flutter/Flutter.h>
#import <OpenAliPaySDK/OpenAliSDK.h>

@interface TobiasPlugin : NSObject<FlutterPlugin>
+(BOOL)handleOpenURL:(NSURL*)url;
@end
