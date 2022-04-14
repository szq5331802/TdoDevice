
#import "MainViewController.h"
#import "BindViewController.h"
#import <TdoDevice/TdoDeviceApi.h>

@interface MainViewController () <TdoDeviceDelegate>
@property (weak, nonatomic) IBOutlet UIView *mViewRoot;

@property (nonatomic, retain) NSArray<UserDevice*>* deviceList;
@end

@implementation MainViewController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    //当前支持的旋转类型
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    // 是否支持旋转
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    // 默认进去类型
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[TdoDeviceApi getInstance] initWithAppKey:@"10000" appSecret:@"aosaoiopajfpiafdsaoagwed" debug:YES delegate:self];
    [[TdoDeviceApi getInstance] getUserDeviceList:@"testIos1"];
    [self updateUserDevice];
}

- (void)onUpdateBind:(NSArray<UserDevice*>*)deviceList {
    self.deviceList = deviceList;
    [self updateUserDevice];
}

- (void)updateUserDevice {
    int row = 3;
    CGFloat margin = 10;
    CGFloat w = ([UIScreen mainScreen].bounds.size.width-(row+1)*margin)/row;
    NSArray<UIButton*>* subViews = self.mViewRoot.subviews;
    int i = 0;
    for (; i <= self.deviceList.count; i++) {
        UserDevice* device = nil;
        if (i < self.deviceList.count) {
            device = self.deviceList[i];
        }
        
        UIButton* btn = nil;
        if (i < subViews.count) {
            btn = subViews[i];
        } else {
            btn = [UIButton new];
            btn.tag = i;
            btn.backgroundColor = UIColor.grayColor;
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            CGFloat x = (i%row)*(margin+w)+margin;
            CGFloat y = ((int)(i/row))*(margin+w)+margin;
            btn.frame = CGRectMake(x, y, w, w);
            [self.mViewRoot addSubview:btn];
        }
        
        if (device) {
            [btn setTitle:@"" forState:UIControlStateNormal];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSURL* imageURL = [NSURL URLWithString:device.deviceInfo.iconUrl];
                NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [btn setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                });
            });
        } else {
            [btn setImage:nil forState:UIControlStateNormal];
            [btn setTitle:@"添加" forState:UIControlStateNormal];
        }
    }
    
    while (self.mViewRoot.subviews.count > i) {
        [self.mViewRoot.subviews.lastObject removeFromSuperview];
    }
}

- (void)btnClick:(UIButton*)btn {
    if (btn.tag < self.deviceList.count) {
        UserDevice* device = self.deviceList[btn.tag];
        [[TdoDeviceApi getInstance] connect:self.navigationController device:device];
    } else {
        [self.navigationController performSegueWithIdentifier:@"bindDevice" sender:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
