//
//  TCAddressDetailHeaderView.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/15.
//  Copyright © 2018年 wsl. All rights reserved.
//  联系人详情头部View

#import "TCAddressDetailHeaderView.h"
#import "TalkChainHeader.h"

@implementation TCAddressDetailHeaderView

#pragma mark - lazyload
- (UIImageView *)topBgImageView{
    if (!_topBgImageView) {
        _topBgImageView = [UIImageView new];
        _topBgImageView.backgroundColor = cLightGrayColor;
        [self addSubview:_topBgImageView];
        [_topBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(@(SCREEN_HEIGHT / 3.0));
        }];
    }
    return _topBgImageView;
}


- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _backButton.tintColor = cWhiteColor;
        [_backButton setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
        [self insertSubview:_backButton aboveSubview:self.topBgImageView];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.width.height.equalTo(@30);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(10);
            } else {
                make.top.equalTo(self).offset(30);
            }
        }];
    }
    return _backButton;
}

- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = cLightGrayColor;
        _avatarImageView.layer.cornerRadius = 45;
        _avatarImageView.layer.masksToBounds = YES;
        [self insertSubview:_avatarImageView aboveSubview:self.topBgImageView];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.topBgImageView.mas_bottom).offset(30);
            make.width.height.equalTo(@90);
        }];
    }
    return _avatarImageView;
}



- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = BOLD_FONT(17);
        _titleLabel.textColor = cTextColor;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_bottom).offset(20);
            make.centerX.equalTo(self);
            make.bottom.inset(10);
        }];

        UIView *leftLine = [UIView new];
        leftLine.backgroundColor = HEX_COLOR(0xcccccc);
        [self addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10).priorityHigh();
            make.centerY.equalTo(_titleLabel);
            make.height.equalTo(@(LINE_HEIGHT));
            make.right.equalTo(_titleLabel.mas_left).offset(-10);
        }];

        UIView *rightLine = [UIView new];
        rightLine.backgroundColor = HEX_COLOR(0xcccccc);
        [self addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10).priorityHigh();
            make.centerY.equalTo(_titleLabel);
            make.height.equalTo(@(LINE_HEIGHT));
            make.left.equalTo(_titleLabel.mas_right).offset(10);
        }];


    }
    return _titleLabel;
}

@end
