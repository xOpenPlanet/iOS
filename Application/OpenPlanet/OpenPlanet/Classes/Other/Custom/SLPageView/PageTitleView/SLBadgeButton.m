//
//  SLBadgeButton.m
//  OSPMobile
//
//  Created by 王胜利 on 2017/12/20.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import "SLBadgeButton.h"

@interface SLBadgeButton()

/// 未读消息数
@property (strong, nonatomic) UIButton *badgeBtn;

@end
@implementation SLBadgeButton

- (void)setBadge:(NSString *)badge{
    _badge = badge;

    self.badgeBtn.hidden = [badge isEqualToString:@"0"];

    // 加载小红点提醒
    if (badge && badge.length >= 1 && ![badge isEqualToString:@"0"]) {
        [self.badgeBtn setTitle:badge forState:UIControlStateNormal];
        CGSize size = [badge sizeWithAttributes:@{NSFontAttributeName:FONT(10.0)}];
        CGFloat badgeW = size.width<size.height?size.height:size.width;
        [self.badgeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(badgeW + 6, size.height + 6));
        }];
        self.badgeBtn.layer.cornerRadius = size.height/2 + 3;
    }
}


#pragma mark - lazyload
- (UIButton *)badgeBtn{
    if (!_badgeBtn) {
        _badgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_badgeBtn setBackgroundImage:[UIImage ex_imageWithColor:TCThemeColor] forState:UIControlStateNormal];
        _badgeBtn.userInteractionEnabled = NO;
        [_badgeBtn setTitleColor:cWhiteColor forState:UIControlStateNormal];
        _badgeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _badgeBtn.layer.cornerRadius = 5;
        _badgeBtn.layer.masksToBounds = YES;
        _badgeBtn.titleLabel.font = FONT(10.0);
        [self addSubview:_badgeBtn];
        [_badgeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(3);
            make.right.equalTo(self).offset(-3);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
    return _badgeBtn;
}

@end
