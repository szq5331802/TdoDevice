//
//  AppDelegate.m
//  MiAiApp
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic, assign) NSTimeInterval activityTime;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    
    return YES;
}


- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url {
    return YES;
}

- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    return YES;
}

- (BOOL)application:(UIApplication*)application continueUserActivity:(NSUserActivity*)userActivity
 restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSDictionary*)userInfo {
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
}

@end
