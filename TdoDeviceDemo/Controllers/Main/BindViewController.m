
#import "BindViewController.h"
#import <TdoDevice/TdoDeviceApi.h>

@interface BindViewController ()
@property (weak, nonatomic) IBOutlet UIView *mViewRoot;

@property (nonatomic, retain) NSMutableArray<DeviceInfo*>* deviceList;
@end

@implementation BindViewController

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
    [self updateUserDevice];
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

- (void)updateUserDevice {
    self.deviceList = [NSMutableArray new];
    DeviceInfo* device = [DeviceInfo new];
    device.id = 3;
    device.typeId = 1;
    device.name = @"欧瑞斯ORAYS运动手表星火系列";
    device.desc = @"运动手表";
    DeviceInfo* device1 = [DeviceInfo new];
    device1.id = 4;
    device1.typeId = 2;
    device1.name = @"欧瑞斯ORAYS运动小秘";
    device1.desc = @"运动小秘";
    [self.deviceList addObject:device];
    [self.deviceList addObject:device1];
    
    int row = 3;
    CGFloat margin = 10;
    CGFloat w = ([UIScreen mainScreen].bounds.size.width-(row+1)*margin)/row;
    NSArray<UIButton*>* subViews = self.mViewRoot.subviews;
    int i = 0;
    for (; i < self.deviceList.count; i++) {
        DeviceInfo* device = nil;
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
            if (device.id == 3) {
                [btn setImage:[UIImage imageNamed:@"watch"] forState:UIControlStateNormal];
            } else if (device.id == 4) {
                [btn setImage:[UIImage imageNamed:@"run_spirit"] forState:UIControlStateNormal];
            }
        }
    }
    
    while (self.mViewRoot.subviews.count > i) {
        [self.mViewRoot.subviews.lastObject removeFromSuperview];
    }
}

- (void)btnClick:(UIButton*)btn {
    if (btn.tag < self.deviceList.count) {
        DeviceInfo* device = self.deviceList[btn.tag];
        [[TdoDeviceApi getInstance] bind:self.navigationController device:device];
    }
}

@end
