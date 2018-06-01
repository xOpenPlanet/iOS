//
//  TCSetAvatarView.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/12.
//  Copyright © 2018年 wsl. All rights reserved.
//  设置头像View

#import "TCUploadAvatarView.h"


@implementation TCUploadAvatarView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self subTipView];
        self.subTitleLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"titleColor" fromDictName:@"wallet"];
        self.tipLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"tipColor" fromDictName:@"login"];
        self.nextButton.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"nextButtonBgColor" fromDictName:@"login"];
        self.nextButton.theme_tintColor = [UIColor theme_colorPickerForKey:@"nextButtonTintColor" fromDictName:@"login"];
    }
    return self;
}

#pragma mark - lazyload
- (UIButton *)avatarButton{
    if (!_avatarButton) {
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_avatarButton setBackgroundImage:[UIImage theme_bundleImageNamed:@"login/wallet/wallet_default_camera.png"]() forState:UIControlStateNormal];
        [_avatarButton setTitleColor:cBlackColor forState:UIControlStateNormal];
        _avatarButton.layer.cornerRadius = 45;
        _avatarButton.layer.borderColor = cLineBgColor.CGColor;
        _avatarButton.layer.borderWidth = 1.0;
        _avatarButton.layer.masksToBounds  = YES;
        [self addSubview:_avatarButton];
        [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(20);
            make.height.width.equalTo(@90);
        }];
    }
    return _avatarButton;
}



- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.font = BOLD_FONT(17);
        _subTitleLabel.textColor = cDarkGrayColor;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subTitleLabel];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarButton.mas_bottom).offset(5);
            make.left.right.equalTo(self).inset(20);
        }];
    }
    return _subTitleLabel;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = FONT(13);
        _tipLabel.numberOfLines = 0;
        _tipLabel.textColor = TCTipColor;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subTitleLabel.mas_bottom).offset(20);
            make.left.right.equalTo(self).inset(20);
        }];
    }
    return _tipLabel;
}

- (TCWalletSubTipView *)subTipView{
    if (!_subTipView) {
        _subTipView = [TCWalletSubTipView new];
        [self addSubview:_subTipView];
        [_subTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipLabel.mas_bottom).offset(20).priority(100);
            make.top.equalTo(self.tipLabel.mas_bottom).offset(20).priority(200);
            make.centerX.equalTo(self);
            make.left.right.equalTo(self);
        }];
    }
    return _subTipView;
}


- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextButton.tintColor = cWhiteColor;
        _nextButton.layer.cornerRadius = 22.5;
        [self addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).inset(20);
            make.top.equalTo(self.subTipView.mas_bottom).offset(30);
            make.height.equalTo(@45);
            make.centerX.equalTo(self);
        }];
    }
    return _nextButton;
}

@end
