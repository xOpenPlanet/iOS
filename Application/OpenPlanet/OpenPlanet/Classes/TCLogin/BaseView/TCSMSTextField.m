//
//  TCSMSTextField.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/23.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "TCSMSTextField.h"
#import "TalkChainHeader.h"

@implementation TCSMSTextField

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.SMSButton theme_setTitleColor:[UIColor theme_colorPickerForKey:@"tipColor" fromDictName:@"login"] forState:UIControlStateNormal];

        self.SMSTextField.theme_textColor = [UIColor theme_colorPickerForKey:@"textFieldTextColor" fromDictName:@"login"];

    }
    return self;
}


- (UITextField *)SMSTextField{
    if (!_SMSTextField) {
        _SMSTextField = [UITextField new];
        _SMSTextField.borderStyle = UITextBorderStyleNone;
        _SMSTextField.keyboardType = UIKeyboardTypeNumberPad;
        _SMSTextField.font = FONT(15);
        _SMSTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:_SMSTextField];
        [_SMSTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.height.equalTo(@45);
        }];

        UIView *bottomLine = [UIView new];
        bottomLine.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"separatorColor" fromDictName:@"login"];
        [_SMSTextField addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_SMSTextField).inset(-3);
            make.bottom.equalTo(_SMSTextField);
            make.height.equalTo(@1);
        }];

        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 45)];
        [rightView addSubview:self.SMSButton];
        [self.SMSButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(rightView);
        }];

        UIView *line = [UIView new];
        line.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"separatorColor" fromDictName:@"login"];
        [rightView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.inset(10);
            make.width.equalTo(@1);
            make.left.equalTo(self.SMSButton.mas_left).offset(-5);
        }];

        _SMSTextField.rightView = rightView;
        _SMSTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _SMSTextField;
}

- (UIButton *)SMSButton{
    if (!_SMSButton) {
        _SMSButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _SMSButton.titleLabel.font = FONT(14);
    }
    return _SMSButton;
}

@end
