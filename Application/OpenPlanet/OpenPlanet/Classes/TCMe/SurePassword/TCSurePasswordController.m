//
//  TCMeSurePasswordController.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/15.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCSurePasswordController.h"
#import "TalkChainHeader.h"
#import "WalletUtil.h"

@interface TCSurePasswordController ()

@property (assign, nonatomic) BOOL isShowSubTitle;

@end

@implementation TCSurePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"请输入基地密码";
    self.passwordTextField.theme_attributePlaceHolder = [NSAttributedString theme_attributeStringWithString:@"请输入密码"attributeColor:[UIColor theme_colorPickerForKey:@"textFieldPlaceHolderColor" fromDictName:@"login"]];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    if (self.isShowSubTitle) {
        self.subTitleLabel.text = @"基地密码用于解密消息的密码";
    }else{
        [self.subTitleLabel removeFromSuperview];
    }
}

#pragma mark - 动画显示modal视图
+ (instancetype)showWithSuperVc:(UIViewController *)superVc isRight:(PasswordRightBlock)isRight{
    TCSurePasswordController * modalVc = [TCSurePasswordController new];
    if (modalVc.isSuccessBlock != isRight) {
        modalVc.isSuccessBlock = isRight;
    }
    modalVc.isShowSubTitle = NO;
    modalVc.modalPresentationStyle =  UIModalPresentationOverFullScreen;
    /// 自定义弹出动画(将animated设置成NO)
    [superVc presentViewController:modalVc animated:NO completion:nil];
    return modalVc;
}

+ (instancetype)showWithIsRight:(PasswordRightBlock)isRight{
    TCSurePasswordController * modalVc = [TCSurePasswordController new];
    if (modalVc.isSuccessBlock != isRight) {
        modalVc.isSuccessBlock = isRight;
    }
    modalVc.isShowSubTitle = YES;
    modalVc.modalPresentationStyle =  UIModalPresentationOverFullScreen;
    /// 自定义弹出动画(将animated设置成NO)
    [ViewControllerManager presentViewController:modalVc animated:NO completion:nil];
    return modalVc;
}


#pragma mark - 当控制器View加载完成的时候，弹出内容View
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(80);
        } else {
            make.top.equalTo(self.view).offset(80);
        }
    }];
    [self.passwordTextField becomeFirstResponder];
    WEAK(self)
    [UIView animateWithDuration:0.25 animations:^{
        weakself.maskView.alpha = 0.5;
        [weakself.view layoutIfNeeded];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    self.maskView.alpha = 0;
}

#pragma mark - 确认按钮事件
- (void)sureButtonAction{
    NSString *oriPassword = [StringUtil encodeWithMD5:self.passwordTextField.text];
    NSString *storedPassword = [EnvironmentVariable getWalletPasswordWithUserID:[EnvironmentVariable getWalletUserID]];
    if([oriPassword isEqualToString:storedPassword]) {
        // 临时保存钱包密码
        WalletUtilObject.walletPassword = self.passwordTextField.text;
        if (self.isSuccessBlock) {
            [self dismissViewController];
            self.isSuccessBlock(YES,self.passwordTextField.text);
        }
    }else {
        // 密码错误，晃动
        //        [self.contentView ex_shake];
        [self shakeAnimation:self.contentView];
        self.passwordTextField.text = @"";
        self.tipLabel.text = @"密码错误";
        self.tipLabel.hidden = NO;
    }
}


#pragma mark - View晃动
- (void)shakeAnimation:(UIView *)shakeView{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shakeAnimation.duration = 0.05f;
    shakeAnimation.fromValue = [NSNumber numberWithFloat:-10];
    shakeAnimation.toValue = [NSNumber numberWithFloat:10];
    shakeAnimation.autoreverses = YES;
    [shakeView.layer addAnimation:shakeAnimation forKey:nil];
}




- (void)textChange:(UITextField *)textField{
    if (textField.text.length > 0) {
        self.tipLabel.hidden = YES;
    }
}

#pragma mark - 关闭modal视图
- (void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyload
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.backgroundColor = cBlackColor;
        _maskView.alpha = 0;
        [self.view addSubview:_maskView];
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];
        [_maskView ex_addTapGestureWithTarget:self action:@selector(dismissViewController)];
    }
    return _maskView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView  = [UIView new];
        _contentView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];
        _contentView.layer.cornerRadius = 20;
        _contentView.layer.masksToBounds = YES;
        [self.view insertSubview:_contentView aboveSubview:self.maskView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(SCREEN_HEIGHT);
            } else {
                make.top.equalTo(self.view).offset(SCREEN_HEIGHT);
            }
            make.left.right.equalTo(self.view).inset(30);
        }];
    }
    return _contentView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.theme_textColor  = [UIColor theme_colorPickerForKey:@"cellTitle"];
        _titleLabel.font = BOLD_FONT(17);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(20);
            make.top.equalTo(self.contentView).offset(20);
        }];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.theme_textColor  = [UIColor theme_colorPickerForKey:@"tipColor" fromDictName:@"login"];
        _subTitleLabel.font = BOLD_FONT(13);
        [self.contentView addSubview:_subTitleLabel];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(20);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        }];
    }
    return _subTitleLabel;
}

- (UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [UITextField new];
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        _passwordTextField.font = FONT(15);
        _passwordTextField.theme_textColor  = [UIColor theme_colorPickerForKey:@"textFieldTextColor"];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_passwordTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];;
        [self.contentView addSubview:_passwordTextField];
        [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10).priority(100);
            make.top.equalTo(self.subTitleLabel.mas_bottom).offset(10).priority(200);
            make.left.right.equalTo(self.contentView).inset(20);
            make.height.equalTo(@45);
        }];
        
        UIView *bottomLine = [UIView new];
        bottomLine.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"separatorColor"];
        [_passwordTextField addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_passwordTextField).inset(-3);
            make.bottom.equalTo(_passwordTextField);
            make.height.equalTo(@1);
        }];
    }
    return _passwordTextField;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.textColor = cRedColor;
        _tipLabel.font = FONT(13);
        _tipLabel.text = @"密码错误";
        _tipLabel.hidden = YES;
        [self.contentView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordTextField.mas_bottom).offset(5);
            make.left.equalTo(self.passwordTextField);
        }];
    }
    return _tipLabel;
}


- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _sureButton.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"nextButtonBgColor" fromDictName:@"login"];
        _sureButton.theme_tintColor  = [UIColor theme_colorPickerForKey:@"nextButtonTintColor" fromDictName:@"login"];
        _sureButton.layer.cornerRadius = 22.5;
        [_sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sureButton];
        [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.tipLabel.mas_bottom).offset(25);
            make.height.equalTo(@45);
            make.bottom.equalTo(self.contentView).inset(20);
        }];
    }
    return _sureButton;
}

@end
