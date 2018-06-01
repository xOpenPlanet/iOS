//
//  TCPriviteKeyRecoverWalletView.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/28.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "TCPriviteKeyRecoverWalletView.h"
#import "TalkChainHeader.h"

@implementation TCPriviteKeyRecoverWalletView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud" fromDictName:@"wallet"];
        self.tipLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"backUpTipColor" fromDictName:@"wallet"];
        self.nextButton.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"nextButtonBgColor" fromDictName:@"login"];
        self.nextButton.theme_tintColor = [UIColor theme_colorPickerForKey:@"nextButtonTintColor" fromDictName:@"login"];
        self.priviteKeyTextView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"tipColor" fromDictName:@"login"];

    }
    return self;
}

#pragma mark - lazyload
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = FONT(16);
        _tipLabel.numberOfLines = 0;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self).inset(20);
        }];
    }
    return _tipLabel;
}


- (UITextView *)priviteKeyTextView{
    if (!_priviteKeyTextView) {
        _priviteKeyTextView  = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 80)];
        _priviteKeyTextView.textColor = cWhiteColor;
        _priviteKeyTextView.ex_placeholder = @"请输入基地账户私钥";
        _priviteKeyTextView.ex_placeholderColor = cWhiteColor;
        _priviteKeyTextView.font = FONT(15);
        [self addSubview:_priviteKeyTextView];
        [_priviteKeyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipLabel.mas_bottom).offset(15);
            make.left.right.equalTo(self).inset(20);
            make.height.equalTo(@100);
        }];

    }
    return _priviteKeyTextView;
}

- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextButton.layer.cornerRadius = 22.5;
        [self addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).inset(20);
            make.top.equalTo(self.priviteKeyTextView.mas_bottom).offset(30);
            make.height.equalTo(@45);
            make.centerX.equalTo(self);
        }];
    }
    return _nextButton;
}


@end
