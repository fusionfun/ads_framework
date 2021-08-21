#import "AdsFrameworkPlugin.h"
#if __has_include(<ads_framework/ads_framework-Swift.h>)
#import <ads_framework/ads_framework-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ads_framework-Swift.h"
#endif

@implementation AdsFrameworkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAdsFrameworkPlugin registerWithRegistrar:registrar];
}
@end
