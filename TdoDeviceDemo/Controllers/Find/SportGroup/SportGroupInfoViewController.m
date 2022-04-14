
#import "SportGroupInfoViewController.h"
#import "UpdateSportGroupViewController.h"
#import "SportGroupMemberListViewController.h"
#import "UserMainViewController.h"
#import "UIGrayLine.h"
#import "GetPic.h"

@interface SportGroupInfoViewController() <UIScrollViewDelegate, GetPicDelegate> {
}

@property (weak, nonatomic) IBOutlet UIView* mViewHead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* mViewHeadTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* mViewImageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* mViewScrollTop;
@property (weak, nonatomic) IBOutlet UILabel* mViewHeadName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* mViewHeadNameLeft;
@property (weak, nonatomic) IBOutlet UIImageView* mViewHeadUserIcon;
@property (weak, nonatomic) IBOutlet UIButton* mViewHeadBackBtn;
@property (weak, nonatomic) IBOutlet UIGrayLine* mViewHeadLine;
@property (weak, nonatomic) IBOutlet UIView* mViewInfoRoot;
@property (weak, nonatomic) IBOutlet UIImageView* mViewUserBg;
@property (weak, nonatomic) IBOutlet UIImageView* mViewUserIcon;
@property (weak, nonatomic) IBOutlet UIButton* mViewUploadImageBtn;
@property (weak, nonatomic) IBOutlet UIButton* mViewChangeInfoBtn;
@property (weak, nonatomic) IBOutlet UILabel* mViewName;
@property (weak, nonatomic) IBOutlet UILabel* mViewQrcode;
@property (weak, nonatomic) IBOutlet UILabel* mViewMemberNum;
@property (weak, nonatomic) IBOutlet UIImageView* mViewOwnerIcon;
@property (weak, nonatomic) IBOutlet UILabel* mViewSportGroupDesc;
@property (weak, nonatomic) IBOutlet UILabel* mViewRunData;
@property (weak, nonatomic) IBOutlet UILabel* mViewBikeData;
@property (weak, nonatomic) IBOutlet UILabel* mViewStepData;
@property (weak, nonatomic) IBOutlet UILabel* mViewTrainData;
@property (weak, nonatomic) IBOutlet UILabel* mViewCreateTime;
@property (weak, nonatomic) IBOutlet UILabel* mViewMemberNum1;
@property (weak, nonatomic) IBOutlet UIButton* mViewBottomBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* mViewBottomBtnH;
@property (weak, nonatomic) IBOutlet UIScrollView* mViewScroll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* mViewNameW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* mViewNameH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* mViewNameLeft;

@property (nonatomic, retain) SportGroupData* sportGroupData;
@property (nonatomic, retain) UserData* ownerUser;
@property (nonatomic, assign) BOOL isShowHead;
@property (nonatomic, assign) CGFloat headHeight;

@end

@implementation SportGroupInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showBar:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -  初始化UI
- (void)initUI {
    _mViewHeadName.text = @"";
    _mViewHeadTop.constant = KStatusBarHeight;
    ViewBorderRadius(_mViewUserIcon, 40, 2, UIColor.whiteColor);
    ViewRadius(_mViewOwnerIcon, 20);
    ViewRadius(_mViewHeadUserIcon, 20);
    _headHeight = KScreenWidth* 9/16;
    _mViewImageH.constant = _headHeight;
    _mViewScrollTop.constant = _headHeight-16;
    
    _mViewUserBg.contentMode =  UIViewContentModeScaleAspectFill;
    _mViewUserBg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mViewUserBg.clipsToBounds  = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onGetUserInfos:)
                                                 name:Event_Find_OnGetUserInfos
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUpdateSportGroup:)
                                                 name:Event_SportGroup_OnUpdateSportGroup
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLeaveSportGroup:)
                                                 name:Event_SportGroup_OnLeaveSportGroup
                                               object:nil];
    _mViewScroll.delegate = self;
    
    _mViewHead.backgroundColor = UIColor.clearColor;
    _mViewHeadLine.alpha = 0;
    _mViewHeadName.alpha = 0;
    _mViewHeadUserIcon.alpha = 0;
    [_mViewHeadBackBtn setImage:[UIImage imageNamed:@"toodo_back"] forState:UIControlStateNormal];
    
    self.sportGroupData = [ModelSportGroup GetInstance].sportGroups[@(_sportGroupId)];
    if (!_sportGroupData) {
        [[ModelSportGroup GetInstance] sendGetSportGroups:0 limit:20 sportGroupId:_sportGroupId recommend:0 hot:0 latitude:1000 longitude:1000 city:@"" classify:-1 name:@"" qrCode:@""];
    }
}

- (void)setSportGroupData:(SportGroupData*)sportGroupData {
    _sportGroupData = sportGroupData;
    _mViewHeadName.text = _sportGroupData.name;
    _mViewName.text = _sportGroupData.name;
    if (ValidStr(_sportGroupData.icon)) {
        [_mViewHeadUserIcon td_setImageWithURL:_sportGroupData.icon];
        [_mViewUserIcon td_setImageWithURL:_sportGroupData.icon];
    } else {
        _mViewHeadUserIcon.image = [UIImage imageNamed:@"toodo_sport_group_icon"];
        _mViewUserIcon.image = [UIImage imageNamed:@"toodo_sport_group_icon"];
    }
    
    if (ValidStr(_sportGroupData.image)) {
        [_mViewUserBg td_setImageWithURLNoClip:_sportGroupData.image isCacheMemory:NO];
    } else {
        [_mViewUserBg setImage:[UIImage imageNamed:@"toodo_sport_group_main_bg"]];
    }
    
    _mViewQrcode.text = _sportGroupData.qrCode;
    if (_sportGroupData.memberNum > 10000) {
        _mViewMemberNum.text = [NSString stringWithFormat:@"%.1fw", _sportGroupData.memberNum/10000.f];
        _mViewMemberNum1.text = [NSString stringWithFormat:@"%.1fw 名成员", _sportGroupData.memberNum/10000.f];
    } else {
        _mViewMemberNum.text = [NSString stringWithFormat:@"%d", _sportGroupData.memberNum];
        _mViewMemberNum1.text = [NSString stringWithFormat:@"%d 名成员", _sportGroupData.memberNum];
    }
    
    if (_sportGroupData.runDis < 1000) {
        _mViewRunData.text = [NSString stringWithFormat:@"跑步 %d 米", _sportGroupData.runDis];
    } else if (_sportGroupData.runDis < 10000000) {
        _mViewRunData.text = [NSString stringWithFormat:@"跑步 %.1f 公里", _sportGroupData.runDis/1000.f];
    } else {
        _mViewRunData.text = [NSString stringWithFormat:@"跑步 %.1fw 公里", _sportGroupData.runDis/10000000.f];
    }
    
    if (_sportGroupData.bikeDis < 1000) {
        _mViewBikeData.text = [NSString stringWithFormat:@"骑行 %d 米", _sportGroupData.bikeDis];
    } else if (_sportGroupData.bikeDis < 10000000) {
        _mViewBikeData.text = [NSString stringWithFormat:@"骑行 %.1f 公里", _sportGroupData.bikeDis/1000.f];
    } else {
        _mViewBikeData.text = [NSString stringWithFormat:@"骑行 %.1fw 公里", _sportGroupData.bikeDis/10000000.f];
    }
    
    if (_sportGroupData.steps < 10000) {
        _mViewStepData.text = [NSString stringWithFormat:@"计步 %d 步", _sportGroupData.steps];
    } else {
        _mViewStepData.text = [NSString stringWithFormat:@"计步 %.1fw 步", _sportGroupData.steps/10000.f];
    }
    
    int min = ceil(_sportGroupData.trainTime/60.f);
    if (min >= 60) {
        _mViewTrainData.text = [NSString stringWithFormat:@"健身 %d 小时 %d 分钟", min/60, min%60];
    } else {
        _mViewTrainData.text = [NSString stringWithFormat:@"健身 %d 分钟", min];
    }
    
    UserData* selfUser = [ModelMine GetInstance].userData;
    if (_sportGroupData.userId == selfUser.userId) {
        self.ownerUser = selfUser;
    } else {
        self.ownerUser = [ModelFind GetInstance].userDatas[@(_sportGroupData.userId)];
    }
    
    if (!_ownerUser) {
        [[ModelMine GetInstance] sendGetUserInfos:_sportGroupData.userId];
    }
    
    NSString* content = _sportGroupData.desc ? _sportGroupData.desc : @"";
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 1.2;
    paragraphStyle.lineHeightMultiple = 1.3;
    
    NSDictionary* attributes = @{
        NSForegroundColorAttributeName:UIColor.lightGrayColor,
        NSParagraphStyleAttributeName:paragraphStyle,
        NSFontAttributeName:_mViewSportGroupDesc.font
    };
    
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    _mViewSportGroupDesc.attributedText = attrStr;
    [_mViewSportGroupDesc sizeToFit];
    
    _mViewCreateTime.text = [DateUtil timeToDate:@"yyyy-MM-dd HH:mm" time:_sportGroupData.createTime];
    
    _mViewUploadImageBtn.hidden = YES;
    _mViewChangeInfoBtn.hidden = YES;
    if (_sportGroupData.isJoin == 0) {
        _mViewBottomBtnH.constant = 0;
    } else {
        NSString* title = @"等待审核";
        _mViewBottomBtn.enabled = NO;
        _mViewBottomBtn.backgroundColor = UIColor.lightGrayColor;
        _mViewBottomBtnH.constant = 50;
        if (_sportGroupData.state == 2) {
            title = @"审核失败";
        } else if (_sportGroupData.state == 3) {
            title = @"已解散";
        } else if (_sportGroupData.state == 1) {
            title = @"退出运动团";
            _mViewBottomBtn.enabled = YES;
            _mViewBottomBtn.backgroundColor = C_App_Hight;
            UserData* userData = [ModelMine GetInstance].userData;
            if (_sportGroupData.userId == userData.userId) {
                title = @"解散运动团";
                _mViewUploadImageBtn.hidden = NO;
                _mViewChangeInfoBtn.hidden = NO;
            }
        }
        [_mViewBottomBtn setTitle:title forState:UIControlStateNormal];
    }
    
    CGSize size = [_mViewName sizeThatFits:CGSizeMake(999999, _mViewNameH.constant)];
    CGFloat maxW = KScreenWidth-_mViewNameLeft.constant-30-(_mViewChangeInfoBtn.isHidden?0:_mViewChangeInfoBtn.width);
    _mViewNameW.constant = MIN(maxW, size.width);
}

- (void)setOwnerUser:(UserData*)ownerUser {
    _ownerUser = ownerUser;
    if (!_ownerUser) {
        [_mViewOwnerIcon setImage:[UIImage imageNamed:@"icon_avatar_img"]];
        return;
    }
    
    if (ValidStr(_ownerUser.userImg)) {
        [_mViewOwnerIcon td_setImageWithURL:_ownerUser.userImg];
    } else {
        [_mViewOwnerIcon setImage:[UIImage imageNamed:@"icon_avatar_img"]];
    }
}

- (void)showHead:(BOOL)show {
    _isShowHead = show;
    if (_isShowHead) {
        [UIView animateWithDuration:0.3 animations:^{
            _mViewHead.backgroundColor = UIColor.whiteColor;
            _mViewHeadLine.alpha = 1;
            _mViewHeadName.alpha = 1;
            _mViewHeadUserIcon.alpha = 1;
            [_mViewHeadBackBtn setImage:[UIImage imageNamed:@"toodo_back_black"] forState:UIControlStateNormal];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            _mViewHead.backgroundColor = UIColor.clearColor;
            _mViewHeadLine.alpha = 0;
            _mViewHeadName.alpha = 0;
            _mViewHeadUserIcon.alpha = 0;
            [_mViewHeadBackBtn setImage:[UIImage imageNamed:@"toodo_back"] forState:UIControlStateNormal];
        }];
    }
}

- (void)onSelPic:(NSString*)picPath image:(UIImage*)image {
    if (picPath != nil && ![picPath isEqualToString:@""]) {
        [[ModelSportGroup GetInstance] sendUpdateSportGroup:_sportGroupId name:nil classify:-1 icon:nil image:picPath desc:nil latitude:1000 longitude:1000 location:nil city:nil];
    }
}

- (IBAction)onBack:(id)sender {
    [self backBtnClicked];
}

- (IBAction)onUploadImage:(id)sender {
    if (!_sportGroupData ||
        (_sportGroupData.state != 0 && _sportGroupData.state != 1)) {
        return;
    }
    
    CGFloat w = 720;
    CGFloat h = 720* 9/16.f;
    [GetPic getPic:@"请选择运动团背景" w:w h:h a:YES viewCtroller:self delegate:self];
}

- (IBAction)onChangeInfo:(id)sender {
    if (!_sportGroupData ||
        (_sportGroupData.state != 0 && _sportGroupData.state != 1)) {
        return;
    }
    
    UpdateSportGroupViewController* VC = [UpdateSportGroupViewController new];
    VC.sportGroupData = _sportGroupData;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)onMemberList:(id)sender {
    if (!_sportGroupData ||
        (_sportGroupData.state != 0 && _sportGroupData.state != 1)) {
        return;
    }
    
    SportGroupMemberListViewController* VC = [SportGroupMemberListViewController new];
    VC.sportGroupData = _sportGroupData;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)onOwnerInfo:(id)sender {
    if (!_ownerUser) {
        return;
    }
    
    UserMainViewController* VC = [UserMainViewController new];
    VC.userId = _ownerUser.userId;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)onBottomClick:(id)sender {
    if (!_sportGroupData && _sportGroupData.state != 1) {
        return;
    }
    
    UserData* userData = [ModelMine GetInstance].userData;
    NSString* title = _sportGroupData.userId == userData.userId ? @"确定解散此运动团吗?" : nil;
    NSString* msg = _sportGroupData.userId == userData.userId ? @"运动团解散后所有数据一起删除，不能恢复！" : @"是否退出运动团";
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction* _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action) {
        [[ModelSportGroup GetInstance] sendLeaveSportGroup:_sportGroupId userId:userData.userId];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)onGetUserInfos:(NSNotification*)notification {
    NSDictionary* data = notification.object;
    UserData* userData = data[@"userData"];
    if (!_sportGroupData || !userData || userData.userId != _sportGroupData.userId) {
        return;
    }
    
    self.ownerUser = userData;
}

- (void)onUpdateSportGroup:(NSNotification*)notification {
    NSDictionary* data = notification.object;
    SportGroupData* sportGroupData = data[@"sportGroupData"];
    if (!sportGroupData || _sportGroupId != sportGroupData.id) {
        return;
    }
    
    self.sportGroupData = sportGroupData;
}

- (void)onLeaveSportGroup:(NSNotification*)notification {
    NSDictionary* data = notification.object;
    int code = ValidNum(data[@"code"]) ? [data[@"code"] intValue] : -1;
    NSString* msg = ValidStr(data[@"msg"]) ? data[@"msg"] : @"";
    long long userId = ValidNum(data[@"userId"]) ? [data[@"userId"] longLongValue] : -1;
    long long sportGroupId = ValidNum(data[@"sportGroupId"]) ? [data[@"sportGroupId"] longLongValue] : -1;
    UserData* userData = [ModelMine GetInstance].userData;
    if (code != 0 || sportGroupId != _sportGroupId || userId != userData.userId) {
        return;
    }
    
    [self backBtnClicked];
}

#pragma ---------------------scroll view callback----------------------
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    float offsetY = [scrollView mj_offsetY];
    if (offsetY < 0) {
        _mViewImageH.constant = _headHeight - offsetY;
    } else {
        _mViewImageH.constant = _headHeight;
    }
    
    CGFloat headH = _mViewScrollTop.constant+16;
    if (offsetY < headH && _isShowHead) {
        [self showHead:NO];
    } else if (offsetY >= headH && !_isShowHead) {
        [self showHead:YES];
    }
}

@end
