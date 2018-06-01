//
//  TCPrivateView.m
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/26.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCIsAgreePrivatePolicyView.h"
#import "TalkChainHeader.h"
#import "ThemeKit.h"

@implementation TCIsAgreePrivatePolicyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud" fromDictName:@"wallet"];

        [self.agreementButton theme_setTitleColor:[UIColor theme_colorPickerForKey:@"privateColor" fromDictName:@"wallet"] forState:UIControlStateNormal];
        [self.agreeAgreementButton theme_setTitleColor:[UIColor theme_colorPickerForKey:@"isAgreePrivateColor" fromDictName:@"wallet"] forState:UIControlStateNormal];

        [self.agreeAgreementButton setTitle:@"我已经仔细阅读并同意" forState:UIControlStateNormal];
        [self.agreementButton setTitle:@"服务与隐私条款" forState:UIControlStateNormal];
        self.isAgree = YES;
        [self changeIsAgreeButtonImage];
        [self.agreeAgreementButton addTarget:self action:@selector(agreeAgreementButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.agreementButton addTarget:self action:@selector(agreementButtonAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

- (void)agreeAgreementButtonAction{
    self.isAgree = !self.isAgree;
    [self changeIsAgreeButtonImage];

    if (self.agreeAgreementButtonActionBlock) {
        self.agreeAgreementButtonActionBlock();
    }
}
- (void)agreementButtonAction{
    if (self.agreementButtonActionBlock) {
        self.agreementButtonActionBlock();
    }
}

#pragma mark - 修改是否同意隐私协议
- (void)changeIsAgreeButtonImage{
    NSString *imageName = [NSString stringWithFormat:@"login/wallet/%@",self.isAgree ? @"wallet_private_selected@3x.png":@"wallet_private_noSelect@3x.png"];
    UIImage *image =  [UIImage theme_bundleImageNamed:imageName]();
    [self.agreeAgreementButton setImage:image forState:UIControlStateNormal];
}


#pragma mark - lazyload
- (UIButton *)agreeAgreementButton{
    if (!_agreeAgreementButton) {
        _agreeAgreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeAgreementButton.titleLabel.font = FONT(13);
        [self addSubview:_agreeAgreementButton];
        [_agreeAgreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.height.equalTo(@30);
        }];
    }
    return _agreeAgreementButton;
}

- (UIButton *)agreementButton{
    if (!_agreementButton) {
        _agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreementButton.titleLabel.font = FONT(13);
        [self addSubview:_agreementButton];
        [_agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.agreeAgreementButton.mas_right);
            make.top.bottom.equalTo(self.agreeAgreementButton);
        }];
    }
    return _agreementButton;
}


@end
