
#import "SportRankingViewController.h"
#import "UISportRankingCell.h"
#import "UIHeadRoot.h"

#define RANKING_SEL_ALL 0
#define RANKING_SEL_FRIEND  1

@interface SportRankingViewController () <UITableViewDelegate, UITableViewDataSource, UIHeadRootDelegate> {
}

@property (weak, nonatomic) IBOutlet UIHeadRoot* mViewHead;
@property (weak, nonatomic) IBOutlet UITableView* mViewTableView;
@property (weak, nonatomic) IBOutlet UIButton* mViewSelRankingBtn;
@property (weak, nonatomic) IBOutlet UIButton* mViewSelFriendBtn;

@property (retain, nonatomic) NSMutableArray* rankings;
@property (assign, nonatomic) int sel;
@property (assign, nonatomic) int rankingSize;
@property (assign, nonatomic) BOOL hasUpdateAll;
@property (assign, nonatomic) BOOL hasUpdateFriend;
@end

@implementation SportRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onGetSportRankingWeek:)
                                                 name:Event_Sport_OnGetSportRankingWeek
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onGetSportRankingWeekFriend:)
                                                 name:Event_Sport_OnGetSportRankingWeekFriend
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showBar:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -  初始化UI
- (void)initUI {
    _mViewHead.delegate = self;
    [_mViewHead setTitle:@"排行榜"];
    self.rankings = [NSMutableArray new];
    
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:_mViewSelRankingBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = _mViewSelRankingBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.lineWidth = 1.f;
    maskLayer.lineCap = kCALineCapSquare;
    maskLayer.strokeColor = C_App_Hight.CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    [_mViewSelRankingBtn.layer addSublayer:maskLayer];
    
    maskPath = [UIBezierPath bezierPathWithRoundedRect:_mViewSelRankingBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
    maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = _mViewSelRankingBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    _mViewSelRankingBtn.layer.mask = maskLayer;
    
    maskPath = [UIBezierPath bezierPathWithRoundedRect:_mViewSelFriendBtn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
    maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = _mViewSelFriendBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.lineWidth = 1.f;
    maskLayer.lineCap = kCALineCapSquare;
    maskLayer.strokeColor = C_App_Hight.CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    [_mViewSelFriendBtn.layer addSublayer:maskLayer];
    
    maskPath = [UIBezierPath bezierPathWithRoundedRect:_mViewSelFriendBtn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
    maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = _mViewSelFriendBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    _mViewSelFriendBtn.layer.mask = maskLayer;
    
    _mViewTableView.separatorStyle = UITableViewCellEditingStyleNone;
    _mViewTableView.backgroundColor = UIColor.clearColor;
    _mViewTableView.backgroundView.backgroundColor = UIColor.clearColor;
    _mViewTableView.delegate = self;
    _mViewTableView.dataSource = self;

    _rankingSize = 0;
    _hasUpdateAll = YES;
    _hasUpdateFriend = YES;
    
    [self selAll];
}

- (void)selAll {
    _sel = RANKING_SEL_ALL;
    _mViewSelRankingBtn.backgroundColor = C_App_Hight;
    _mViewSelRankingBtn.enabled = NO;
    _mViewSelFriendBtn.backgroundColor = UIColor.clearColor;
    _mViewSelFriendBtn.enabled = YES;
    
    NSMutableArray<SportRankingWeek*>* rankings = [[ModelSport GetInstance] getSportRankingWeekByType:_type];
    
    if (rankings == nil) {
        rankings = [NSMutableArray new];
    }
    
    [_rankings removeAllObjects];
    [_rankings addObjectsFromArray:rankings];
    _rankingSize = (int)_rankings.count;
    [_mViewTableView reloadData];
}

- (void)selFriend {
    _sel = RANKING_SEL_FRIEND;
    _mViewSelRankingBtn.backgroundColor = UIColor.clearColor;
    _mViewSelRankingBtn.enabled = YES;
    _mViewSelFriendBtn.backgroundColor = C_App_Hight;
    _mViewSelFriendBtn.enabled = NO;
    
    NSMutableArray<SportRankingWeek*>* rankings = [[ModelSport GetInstance] getSportRankingWeekFriendByType:_type];
    
    if (rankings == nil) {
        rankings = [NSMutableArray new];
    }
    
    [_rankings removeAllObjects];
    [_rankings addObjectsFromArray:rankings];
    _rankingSize = (int)_rankings.count;
    [_mViewTableView reloadData];
}

- (IBAction)onSelRanking:(id)sender {
    [self selAll];
}

- (IBAction)onSelFriend:(id)sender {
    [self selFriend];
}

- (void)onGetSportRankingWeek:(NSNotification*)notification {
    NSDictionary* data = notification.object;
    int code = ValidNum(data[@"code"]) ? [data[@"code"] intValue] : -1;
    NSString* msg = ValidStr(data[@"msg"]) ? data[@"msg"] : @"";
    
    if (code != 0) {
        return;
    }
    
    if (_sel == RANKING_SEL_ALL) {
        NSMutableArray<SportRankingWeek*>* rankings = [[ModelSport GetInstance] getSportRankingWeekByType:_type];
        if (rankings == nil || rankings.count <= _rankingSize) {
            _hasUpdateAll = NO;
        }
        [self selAll];
    }
}

- (void)onGetSportRankingWeekFriend:(NSNotification*)notification {
    NSDictionary* data = notification.object;
    int code = ValidNum(data[@"code"]) ? [data[@"code"] intValue] : -1;
    NSString* msg = ValidStr(data[@"msg"]) ? data[@"msg"] : @"";
    
    if (code != 0) {
        return;
    }
    
    if (_sel == RANKING_SEL_FRIEND) {
        NSMutableArray<SportRankingWeek*>* rankings = [[ModelSport GetInstance] getSportRankingWeekFriendByType:_type];
        if (rankings == nil || rankings.count <= _rankingSize) {
            _hasUpdateFriend = NO;
        }
        [self selFriend];
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return _rankings.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    SportRankingWeek* data = indexPath.row < _rankings.count ? _rankings[indexPath.row] : nil;
    UISportRankingCell* item = [tableView dequeueReusableCellWithIdentifier:@"item"];
    if (item == nil) {
        item = [[UISportRankingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"item"];
        item.backgroundColor = [UIColor clearColor];
        item.backgroundView.backgroundColor = [UIColor clearColor];
        item.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    item.num = (int)indexPath.row+1;
    if (data != nil) {
        item.ranking = data;
    }
    
    if (indexPath.row == _rankings.count-1) {
        if (_sel == RANKING_SEL_ALL && _hasUpdateAll) {
            [[ModelSport GetInstance] sendGetSportRankingWeekByType:_type offset:(int)_rankings.count limit:50];
        } else if (_sel == RANKING_SEL_FRIEND && _hasUpdateFriend) {
            [[ModelSport GetInstance] sendGetSportRankingWeekFriendByType:_type offset:(int)_rankings.count limit:50];
        }
    }
    
    return item;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 60;
}

@end
