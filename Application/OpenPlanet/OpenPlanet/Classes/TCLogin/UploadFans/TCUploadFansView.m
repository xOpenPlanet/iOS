//
//  TCUploadFansView.m
//  OpenPlanet
//
//  Created by 王胜利 on 2018/5/2.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCUploadFansView.h"
#import "TalkChainHeader.h"

@implementation TCUploadFansView

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
- (UIImageView *)subTitleImageView{
    if (!_subTitleImageView) {
        _subTitleImageView = [UIImageView new];
        UIImage *walletTopImage = [UIImage theme_bundleImageNamed:@"login/wallet/wallet_backup_top.png"]();
        _subTitleImageView.image = walletTopImage;
        [self addSubview:_subTitleImageView];
        [_subTitleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self);
            make.width.equalTo(@150);
            make.height.equalTo(@(150*walletTopImage.size.height/walletTopImage.size.width));
        }];
    }
    return _subTitleImageView;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.font = BOLD_FONT(17);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subTitleLabel];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10).priority(100);
            make.top.equalTo(self.subTitleImageView.mas_bottom).offset(5).priority(200);
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
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subTitleLabel.mas_bottom).offset(10).priority(200);
            make.top.equalTo(self.subTitleImageView.mas_bottom).offset(5).priority(100);
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
            make.top.equalTo(self.tipLabel.mas_bottom).offset(20);
            make.centerX.equalTo(self);
            make.left.right.equalTo(self);
        }];

    }
    return _subTipView;
}

- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
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
