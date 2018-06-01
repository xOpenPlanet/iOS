//
//  TCInviteCodeView.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/31.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "TCInviteCodeView.h"
#import "TalkChainHeader.h"
#define kBundlePath [[NSBundle mainBundle] pathForResource:@"Planet.bundle" ofType:nil]

@implementation TCInviteCodeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
        self.bgScrollView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
        self.bgImageView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
        self.contentBgImageView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];;

        self.inviteCodeTitleLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"inviteColdeTintColor" fromDictName:@"opMe"];
        self.inviteCodeLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"inviteColdeTintColor" fromDictName:@"opMe"];
        self.inviteCodeCopyButton.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"inviteColdeTintColor" fromDictName:@"opMe"];
        UIImage *starrySkyImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Planet/StarrySky/StarrySkyBackground.png", kBundlePath]];
        self.bgImageView.image = starrySkyImage;

    }
    return self;
}

#pragma mark - lazyload
- (UIView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [UIView new];
        [self addSubview:_bgScrollView];
        [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _bgScrollView;
}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.bgScrollView addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bgScrollView);
        }];
    }
    return _bgImageView;
}


- (UIImageView *)contentBgImageView{
    if (!_contentBgImageView) {
        _contentBgImageView = [UIImageView new];
        _contentBgImageView.backgroundColor = cWhiteColor;
        _contentBgImageView.userInteractionEnabled = YES;
        _contentBgImageView.layer.cornerRadius = 10;
        _contentBgImageView.layer.masksToBounds = YES;
        [self.bgImageView addSubview:_contentBgImageView];
        [_contentBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.bgImageView);
            make.left.right.equalTo(self.bgImageView).inset(20);
        }];
    }
    return _contentBgImageView;
}

- (UILabel *)inviteCodeTitleLabel{
    if (!_inviteCodeTitleLabel) {
        _inviteCodeTitleLabel = [UILabel new];
        _inviteCodeTitleLabel.font = BOLD_FONT(18);
        _inviteCodeTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentBgImageView addSubview:_inviteCodeTitleLabel];
        [_inviteCodeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentBgImageView).inset(20);
        }];
    }
    return _inviteCodeTitleLabel;
}
- (UILabel *)inviteCodeLabel{
    if (!_inviteCodeLabel) {
        _inviteCodeLabel = [UILabel new];
        _inviteCodeLabel.font = BOLD_FONT(30);
        _inviteCodeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentBgImageView addSubview:_inviteCodeLabel];
        [_inviteCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentBgImageView).inset(20);
            make.top.equalTo(self.inviteCodeTitleLabel.mas_bottom).offset(10);
        }];
    }
    return _inviteCodeLabel;
}

- (UIButton *)inviteCodeCopyButton{
    if (!_inviteCodeCopyButton) {
        _inviteCodeCopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _inviteCodeCopyButton.tintColor = cWhiteColor;
        _inviteCodeCopyButton.layer.cornerRadius = 5;
        _inviteCodeCopyButton.layer.masksToBounds = YES;
        [self.contentBgImageView addSubview:_inviteCodeCopyButton];
        [_inviteCodeCopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentBgImageView);
            make.top.equalTo(self.inviteCodeLabel.mas_bottom).offset(10);
            make.size.mas_offset(CGSizeMake(100, 40));
        }];
    }
    return _inviteCodeCopyButton;
}

- (UILabel *)rewardLabel{
    if (!_rewardLabel) {
        _rewardLabel = [UILabel new];
        _rewardLabel.font = FONT(13);
        _rewardLabel.numberOfLines = 0;
        _rewardLabel.textAlignment = NSTextAlignmentCenter;
        _rewardLabel.textColor = cLightGrayColor;
        [self.contentBgImageView addSubview:_rewardLabel];
        [_rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentBgImageView).inset(20);
            make.top.equalTo(self.inviteCodeCopyButton.mas_bottom).offset(10);
        }];
    }
    return _rewardLabel;
}

- (UIImageView *)qrImageView{
    if (!_qrImageView) {
        _qrImageView = [UIImageView new];
        _qrImageView.backgroundColor = cWhiteColor;
        [self.contentBgImageView addSubview:_qrImageView];
        [_qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rewardLabel.mas_bottom).offset(20);
            make.centerX.equalTo(self.contentBgImageView);
            make.width.height.equalTo(@120);
        }];
    }
    return _qrImageView;
}

- (UILabel *)qrLabel{
    if (!_qrLabel) {
        _qrLabel = [UILabel new];
        _qrLabel.textColor = cLightGrayColor;
        _qrLabel.font = FONT(13);
        _qrLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentBgImageView addSubview:_qrLabel];
        [_qrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentBgImageView).inset(20);
            make.top.equalTo(self.qrImageView.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentBgImageView).offset(-20);
        }];
    }
    return _qrLabel;
}

@end
