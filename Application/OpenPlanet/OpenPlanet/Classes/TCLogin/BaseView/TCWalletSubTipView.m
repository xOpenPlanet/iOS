//
//  TCWalletSubTipView.m
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/23.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCWalletSubTipView.h"
#import "TalkChainHeader.h"
#import "FLAnimatedImage.h"

@implementation TCWalletSubTipView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.tipLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"subTipColor" fromDictName:@"wallet"];
        self.rewardLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"rewardTexTColor" fromDictName:@"wallet"];
        NSData *data = [NSData theme_dataPickerForPath:@"login/wallet/wallet_silverDiamond.gif"]();
        self.rewardImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];

    }
    return self;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = FONT(14);
        _tipLabel.numberOfLines = 0;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.contentView.mas_top).offset(-20).priority(200);
            make.bottom.equalTo(self).priority(100);
        }];

        UIView *leftLine = [UIView new];
        leftLine.theme_backgroundColor  = [UIColor theme_colorPickerForKey:@"subTipColor" fromDictName:@"wallet"];
        [self addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.centerY.equalTo(_tipLabel);
            make.height.equalTo(@1);
            make.right.equalTo(_tipLabel.mas_left).offset(-10);
        }];

        UIView *rightLine = [UIView new];
        rightLine.theme_backgroundColor  = [UIColor theme_colorPickerForKey:@"subTipColor" fromDictName:@"wallet"];
        [self addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.centerY.equalTo(_tipLabel);
            make.height.equalTo(@1);
            make.left.equalTo(_tipLabel.mas_right).offset(10);
        }];
    }
    return _tipLabel;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self);
        }];
    }
    return _contentView;
}

- (UILabel *)rewardLabel{
    if (!_rewardLabel) {
        _rewardLabel = [UILabel new];
        _rewardLabel.font = BOLD_FONT(18);
        [self.contentView addSubview:_rewardLabel];
        [_rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.contentView);
        }];
    }
    return _rewardLabel;
}
- (FLAnimatedImageView *)rewardImageView{
    if (!_rewardImageView) {
        _rewardImageView = [FLAnimatedImageView new];
        [self.contentView addSubview:_rewardImageView];
        [_rewardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rewardLabel.mas_right).offset(5);
            make.top.right.bottom.equalTo(self.contentView);
            make.width.height.equalTo(@30);
        }];
    }
    return _rewardImageView;
}


@end
