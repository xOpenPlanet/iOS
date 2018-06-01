//
//  TCInputPhoneTextField.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/23.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "TCInputPhoneTextField.h"
#import "TalkChainHeader.h"

@implementation TCInputPhoneTextField

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.phoneTextField.theme_textColor = [UIColor theme_colorPickerForKey:@"textFieldTextColor" fromDictName:@"login"];
        [self.phoneAreaCodeButton theme_setTitleColor:[UIColor theme_colorPickerForKey:@"textFieldTextColor" fromDictName:@"login"] forState:UIControlStateNormal];
        self.tintColor = cWhiteColor;
    }
    return self;
}

#pragma mark - lazyload
- (UITextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [UITextField new];
        _phoneTextField.borderStyle = UITextBorderStyleNone;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.font = FONT(15);
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;


        [self addSubview:_phoneTextField];
        [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.height.equalTo(@45);
        }];

        UIView *bottomLine = [UIView new];
        bottomLine.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"separatorColor" fromDictName:@"login"];
        [_phoneTextField addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_phoneTextField).inset(-3);
            make.bottom.equalTo(_phoneTextField);
            make.height.equalTo(@1);
        }];

        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];

        [leftView addSubview:self.phoneAreaCodeButton];
        [self.phoneAreaCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(leftView);
        }];

        UIView *line = [UIView new];
        line.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"separatorColor" fromDictName:@"login"];

        [leftView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.inset(10);
            make.width.equalTo(@1);
            make.left.equalTo(self.phoneAreaCodeButton.mas_right).offset(5);
        }];

        _phoneTextField.leftView = leftView;
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _phoneTextField;
}

- (UIButton *)phoneAreaCodeButton{
    if (!_phoneAreaCodeButton) {
        _phoneAreaCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneAreaCodeButton.titleLabel.font = BOLD_FONT(15);
    }
    return _phoneAreaCodeButton;
}

@end
