#import <Flutter/Flutter.h>


@interface TobiasPlugin : NSObject<FlutterPlugin, FlutterSceneLifeCycleDelegate>
+(BOOL)handleOpenURL:(NSURL*)url;
@end
