//
//  TCPasswordController.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/14.
//  Copyright © 2018年 wsl. All rights reserved.
//  重置密码

#import "TCResetPasswordController.h"
#import "TCLoginBaseView.h"
#import "TCRegisterController.h"

@interface TCResetPasswordController ()<UITextFieldDelegate>

@property (strong, nonatomic) TCLoginBaseView *rootView;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *rePasswordTextField;

@end

@implementation TCResetPasswordController

/// 分离业务和布局(替换主View)
- (void)loadView{
    self.view = self.rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForDismissKeyboard];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.passwordTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - 文本框内容变化时
- (void)textChanged{
    BOOL isNextButtonEnabled = (self.passwordTextField.text.length >= 8 && [self.passwordTextField.text isEqualToString:self.rePasswordTextField.text]);
    self.rootView.nextButton.enabled = isNextButtonEnabled;
    self.rootView.nextButton.alpha= isNextButtonEnabled?1:0.4;
}

#pragma mark - 下一步按钮事件
- (void)nextButtonAction:(UIButton *)sender{
    [self.view endEditing:YES];
    Log(@"重置密码");
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isEqual:self.passwordTextField]) {
        [self.rePasswordTextField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        BOOL isNextButtonEnabled = (self.passwordTextField.text.length >= 8 && [self.passwordTextField.text isEqualToString:self.rePasswordTextField.text]);
        if (isNextButtonEnabled) {
            [self nextButtonAction:self.rootView.nextButton];
        }

    }
    return YES;
}

#pragma mark - 返回
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyload
- (TCLoginBaseView *)rootView{
    if (!_rootView) {
        _rootView = [TCLoginBaseView new];
        _rootView.topBgImageView.image = [UIImage imageNamed:@"login_password_bg"];
        _rootView.tipImageView.image = [UIImage imageNamed:@"login_password"];
        _rootView.titleLabel.text =  @"重置密码";
        [_rootView.nextButton setTitle:@"重置密码" forState:UIControlStateNormal];
        [_rootView.nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rootView.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];

        [_rootView.customView addSubview:self.passwordTextField];
        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_rootView.customView);
            make.height.equalTo(@45);
        }];

        [_rootView.customView addSubview:self.rePasswordTextField];
        [self.rePasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordTextField.mas_bottom).offset(5);
            make.left.right.bottom.equalTo(_rootView.customView);
            make.height.equalTo(@45);
        }];

        /// 同步初始下一步按钮状态
        [self textChanged];



    }
    return _rootView;
}

- (UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [UITextField new];
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        _passwordTextField.font = FONT(15);
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.delegate =  self;
        _passwordTextField.placeholder = @"请输入密码(必须6位以上)";
        [_passwordTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];


        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = cGroupTableViewBackgroundColor;
        [_passwordTextField addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_passwordTextField).inset(-3);
            make.bottom.equalTo(_passwordTextField);
            make.height.equalTo(@1);
        }];
    }
    return _passwordTextField;
}

- (UITextField *)rePasswordTextField{
    if (!_rePasswordTextField) {
        _rePasswordTextField = [UITextField new];
        _rePasswordTextField.borderStyle = UITextBorderStyleNone;
        _rePasswordTextField.font = FONT(15);
        _rePasswordTextField.secureTextEntry = YES;
        _rePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _rePasswordTextField.delegate =  self;
        _rePasswordTextField.placeholder = @"确认密码";
        [_rePasswordTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];


        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = cGroupTableViewBackgroundColor;
        [_rePasswordTextField addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_rePasswordTextField).inset(-3);
            make.bottom.equalTo(_rePasswordTextField);
            make.height.equalTo(@1);
        }];
    }
    return _rePasswordTextField;
}


@end
