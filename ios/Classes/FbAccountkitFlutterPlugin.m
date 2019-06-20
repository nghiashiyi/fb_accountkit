#import "FbAccountkitFlutterPlugin.h"
#import <fb_accountkit_flutter/fb_accountkit_flutter-Swift.h>

@implementation FbAccountkitFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFbAccountkitFlutterPlugin registerWithRegistrar:registrar];
}
@end
