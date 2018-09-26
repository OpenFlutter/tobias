#import <Flutter/Flutter.h>
#import <AlipaySDK/AlipaySDK.h>

@interface TobiasPlugin : NSObject<FlutterPlugin>
+(BOOL)handleOpenURL:(NSURL*)url;
@end
