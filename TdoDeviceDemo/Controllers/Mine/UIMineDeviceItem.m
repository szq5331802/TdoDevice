//
//

#import "UIMineDeviceItem.h"
#import "HandringSettingViewController.h"

@interface UIMineDeviceItem()

@property (weak, nonatomic) IBOutlet UIView* mViewRoot;
@property (weak, nonatomic) IBOutlet UILabel* mViewState;
@property (weak, nonatomic) IBOutlet UILabel* mViewPower;

@end

@implementation UIMineDeviceItem

- (instancetype)init {
    if (self = [super init]) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self addSubview:self.mViewRoot];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onStateChange:)
                                                     name:Event_BT_StateChange
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onBTConnect:)
                                                     name:Event_BT_Connect
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onBTDisconnect:)
                                                     name:Event_BT_Disconnect
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onGetPower:)
                                                     name:Event_Mine_GetPower
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onRSConnect:)
                                                     name:Event_RS_Connect
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onRSDisconnect:)
                                                     name:Event_RS_Disconnect
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onRSGetPower:)
                                                     name:Event_RunSpirit_GetPower
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onFRConnect:)
                                                     name:Event_FR_Connect
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onFRDisconnect:)
                                                     name:Event_FR_Disconnect
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onFRGetPower:)
                                                     name:Event_FitnessRing_GetPower
                                                   object:nil];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (_mViewRoot) {
        [_mViewRoot setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    }
}

- (void)willMoveToWindow:(nullable UIWindow*)newWindow {
    [super willMoveToWindow:newWindow];
}

- (void)didAddSubview:(UIView*)subview {
    [super didAddSubview:subview];
}

- (void)willRemoveSubview:(UIView*)subview {
    [super willRemoveSubview:subview];
}

- (void)setInfo:(DeviceInfoData*)info {
    _info = info;
    if (_info == nil) {
        _mViewState.text = @"未知设备";
        _mViewPower.text = @"";
        return;
    }
    
    _mViewState.text = _info.name;
    [self updateInfo];
}

- (void)updateInfo {
    TDBluetoothDevice* device = nil;
    if (_info.typeId == DT_Type_Handring) {
        device = [TDBluetoothHandRing GetInstance];
    } else if (_info.typeId == DT_Type_RunSpirit) {
        device = [TDBluetoothRunSpirit GetInstance];
    } else if (_info.typeId == DT_Type_FitnessRing) {
        device = [TDBluetoothFitnessRing GetInstance];
    }
    
    if ([TDBluetoothBase getBtState] != CBCentralManagerStatePoweredOn) {
        if ([TDBluetoothBase getBtState] == CBCentralManagerStateUnauthorized) {
            _mViewPower.text = @"未开启蓝牙权限";
        } else {
            _mViewPower.text = @"蓝牙未开启";
        }
    } else if (device) {
        if (device.state == TDBluetoothState_Unlink) {
            _mViewPower.text = @"未连接";
        } else if (device.state == TDBluetoothState_Link) {
            _mViewPower.text = @"正在连接";
        } else {
            UserDeviceInfo* devInfo = [[ModelMine GetInstance] getUserDeviceInfoByType:_info.typeId];
            if (devInfo != nil) {
                _mViewPower.text = [NSString stringWithFormat:@"剩余电量%d%%", devInfo.power];
            } else {
                _mViewPower.text = [NSString stringWithFormat:@"已连接"];
            }
        }
    }
}

- (IBAction)onClick:(id)sender {
    HandringSettingViewController* VC = [HandringSettingViewController new];
    VC.type = _info.typeId;
    [self.viewController.navigationController pushViewController:VC animated:YES];
}

- (void)onStateChange:(NSNotification*)notification {
    NSDictionary* data = notification.object;
    int state = ValidNum(data[@"state"]) ? [data[@"state"] intValue] : -1;
    [self updateInfo];
}

- (void)onBTConnect:(NSNotification*)notification {
    if (!_info || _info.typeId != DT_Type_Handring) {
        return;
    }
    
    [self updateInfo];
}

- (void)onBTDisconnect:(NSNotification*)notification {
    if (!_info || _info.typeId != DT_Type_Handring) {
        return;
    }
    
    [self updateInfo];
}

- (void)onGetPower:(NSNotification*)notification {
    if (!_info || _info.typeId != DT_Type_Handring) {
        return;
    }
    
    NSDictionary* data = notification.object;
    int power = ValidNum(data[@"power"]) ? [data[@"power"] intValue] : 0;
    
    _mViewPower.text = [NSString stringWithFormat:@"剩余电量%d%%", power];
}

- (void)onRSConnect:(NSNotification*)notification {
    if (!_info || _info.typeId != DT_Type_RunSpirit) {
        return;
    }
    
    [self updateInfo];
}

- (void)onRSDisconnect:(NSNotification*)notification {
    if (!_info || _info.typeId != DT_Type_RunSpirit) {
        return;
    }
    
    [self updateInfo];
}

- (void)onRSGetPower:(NSNotification*)notification {
    if (!_info || _info.typeId != DT_Type_RunSpirit) {
        return;
    }
    
    NSDictionary* data = notification.object;
    int power = ValidNum(data[@"power"]) ? [data[@"power"] intValue] : 0;
    
    _mViewPower.text = [NSString stringWithFormat:@"剩余电量%d%%", power];
}

- (void)onFRConnect:(NSNotification*)notification {
    if (!_info || _info.typeId != DT_Type_FitnessRing) {
        return;
    }
    
    [self updateInfo];
}

- (void)onFRDisconnect:(NSNotification*)notification {
    if (!_info || _info.typeId != DT_Type_FitnessRing) {
        return;
    }
    
    [self updateInfo];
}

- (void)onFRGetPower:(NSNotification*)notification {
    if (!_info || _info.typeId != DT_Type_FitnessRing) {
        return;
    }
    
    NSDictionary* data = notification.object;
    int power = ValidNum(data[@"power"]) ? [data[@"power"] intValue] : 0;
    
    _mViewPower.text = [NSString stringWithFormat:@"剩余电量%d%%", power];
}

@end
