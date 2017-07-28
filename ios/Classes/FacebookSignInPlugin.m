#import "FacebookSignInPlugin.h"
#import <facebook_sign_in/facebook_sign_in-Swift.h>

@implementation FacebookSignInPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFacebookSignInPlugin registerWithRegistrar:registrar];
}
@end
