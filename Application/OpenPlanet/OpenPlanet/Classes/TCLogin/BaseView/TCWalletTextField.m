//
//  TCWalletTextField.m
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/23.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCWalletTextField.h"
#import "ThemeKit.h"

@implementation TCWalletTextField

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderStyle = UITextBorderStyleNone;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"textFieldBackgroud" fromDictName:@"wallet"];
        self.theme_textColor  = [UIColor theme_colorPickerForKey:@"textFieldTextColor" fromDictName:@"login"];

        [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [self setAutoresizingMask:UIViewAutoresizingNone];

        UIView *leftView = [UIView new];
        leftView.frame = CGRectMake(0, 0, 10, frame.size.height);
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

@end
