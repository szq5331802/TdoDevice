//
//

#import "UISportRankingCell.h"
#import "UserMainViewController.h"

@interface UISportRankingCell()
@property (weak, nonatomic) IBOutlet UIView* mViewRoot;
@property (weak, nonatomic) IBOutlet UIImageView* mViewRankingBg;
@property (weak, nonatomic) IBOutlet UIImageView* mViewUserIcon;
@property (weak, nonatomic) IBOutlet UILabel* mViewRankingNum;
@property (weak, nonatomic) IBOutlet UILabel* mViewUserName;
@property (weak, nonatomic) IBOutlet UILabel* mViewData;
@property (weak, nonatomic) IBOutlet UILabel* mViewDataUnit;

@end

@implementation UISportRankingCell

- (id)initWithCoder:(NSCoder*)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self.mViewRoot setFrame:self.bounds];
        [self.contentView addSubview:self.mViewRoot];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self.mViewRoot setFrame:self.bounds];
        [self.contentView addSubview:self.mViewRoot];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString*)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self.mViewRoot setFrame:self.bounds];
        [self.contentView addSubview:self.mViewRoot];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (_mViewRoot) {
        [_mViewRoot setFrame:self.bounds];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_mViewRoot) {
        [_mViewRoot setFrame:self.bounds];
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

- (void)initView {
}

- (void)setRanking:(SportRankingWeek*)ranking {
    _ranking = ranking;
    if (_ranking == nil) {
        return;
    }
    
    _mViewRankingNum.text = [NSString stringWithFormat:@"%d", _num];
    _mViewRankingNum.textColor = UIColor.whiteColor;
    _mViewRankingBg.hidden = NO;
    if (_num == 1) {
        _mViewRankingBg.image = [UIImage imageNamed:@"icon_route_ranking_first"];
    } else if (_num == 2) {
        _mViewRankingBg.image = [UIImage imageNamed:@"icon_route_ranking_second"];
    } else if (_num == 3) {
        _mViewRankingBg.image = [UIImage imageNamed:@"icon_route_ranking_third"];
    } else {
        _mViewRankingNum.textColor = UIColor.blackColor;
        _mViewRankingBg.hidden = YES;
    }
    
    _mViewUserIcon.image = [UIImage imageNamed:@"icon_avatar_img"];
    if (ValidStr(_ranking.userImg)) {
        [_mViewUserIcon td_setImageWithURL:_ranking.userImg];
    }
    
    _mViewUserName.text = _ranking.userName;
    if (_ranking.type == Sport_Statistic_Type_Course ||
        _ranking.type == Sport_Statistic_Type_Yoga) {
        _mViewDataUnit.text = @"";
        _mViewDataUnit.hidden = YES;
        _mViewData.text = [NSString stringWithFormat:@"%02d:%02d:%02d", _ranking.timeLen/(60* 60), (_ranking.timeLen%(60* 60))/60, _ranking.timeLen%60];
    } else {
        _mViewDataUnit.text = @"km";
        _mViewDataUnit.hidden = NO;
        _mViewData.text = [NSString stringWithFormat:@"%.2f", _ranking.distance/1000.];
    }
}

- (IBAction)onClick:(id)sender {
    if (!_ranking) {
        return;
    }
    
    UserMainViewController* VC = [UserMainViewController new];
    VC.userId = _ranking.userId;
    [self.viewController.navigationController pushViewController:VC animated:YES];
}

@end
