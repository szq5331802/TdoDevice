//
//  AppDelegate.h
//  MiAiApp
//

#import <UIKit/UIKit.h>

/**
 这里面只做调用，具体实现放到 AppDelegate+AppService 或者Manager里面，防止代码过多不清晰
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow* window;

@end

