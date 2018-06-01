//
//  TCRegisterView.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/28.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "TCRegisterView.h"

@implementation TCRegisterView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud" fromDictName:@"wallet"];
        self.tipLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"tipColor" fromDictName:@"login"];
        self.nextButton.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"nextButtonBgColor" fromDictName:@"login"];
        self.nextButton.theme_tintColor = [UIColor theme_colorPickerForKey:@"nextButtonTintColor" fromDictName:@"login"];
    }
    return self;
}

#pragma mark - lazyload
- (EdgeInsetLabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [EdgeInsetLabel new];
        _tipLabel.edgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
        _tipLabel.font = FONT(14);
        _tipLabel.numberOfLines = 0;
        [self addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).inset(20);
        }];
    }
    return _tipLabel;
}

- (TCWalletTextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [TCWalletTextField new];
        _nameTextField.font = FONT(15);
        _nameTextField.returnKeyType = UIReturnKeyNext;
        [self addSubview:_nameTextField];
        [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).inset(20);
            make.top.equalTo(self.tipLabel.mas_bottom).offset(20);
            make.height.equalTo(@45);
        }];
    }
    return _nameTextField;
}

- (TCWalletTextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [TCWalletTextField new];
        _passwordTextField.font = FONT(15);
        _passwordTextField.secureTextEntry = YES;
        [self addSubview:_passwordTextField];
        [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).inset(20);
            make.top.equalTo(self.nameTextField.mas_bottom).offset(10);
            make.height.equalTo(@45);
        }];
    }
    return _passwordTextField;
}

- (TCWalletTextField *)rePasswordTextField{
    if (!_rePasswordTextField) {
        _rePasswordTextField = [TCWalletTextField new];
        _rePasswordTextField.font = FONT(15);
        _rePasswordTextField.secureTextEntry = YES;
        [self addSubview:_rePasswordTextField];
        [_rePasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).inset(20);
            make.top.equalTo(self.passwordTextField.mas_bottom).offset(10);
            make.height.equalTo(@45);
        }];
    }
    return _rePasswordTextField;
}


- (TCIsAgreePrivatePolicyView *)isAgreePrivateView{
    if (!_isAgreePrivateView) {
        _isAgreePrivateView = [TCIsAgreePrivatePolicyView new];
        [self addSubview:_isAgreePrivateView];
        [_isAgreePrivateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.rePasswordTextField);
            make.top.equalTo(self.rePasswordTextField.mas_bottom).offset(5);
        }];
    }
    return _isAgreePrivateView;
}

- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextButton.layer.cornerRadius = 22.5;
        [self addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).inset(20);
            make.top.equalTo(self.isAgreePrivateView.mas_bottom).offset(30);
            make.height.equalTo(@45);
            make.centerX.equalTo(self);
        }];
    }
    return _nextButton;
}

@end
