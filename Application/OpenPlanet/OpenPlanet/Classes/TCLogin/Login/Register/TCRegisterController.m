//
//  TCRegisterController.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/9.
//  Copyright © 2018年 wsl. All rights reserved.
//  4.注册安全账户

#import "TCRegisterController.h"
#import "TalkChainHeader.h"
#import "TCRegisterView.h"
#import "TCPrivateController.h"
#import "TCWalletTipController.h"
#import "UIViewController+TCHUD.h"

@interface TCRegisterController ()<UITextFieldDelegate>

@property (strong, nonatomic) TCRegisterView *rootView;

@end

@implementation TCRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建安全账户";
    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud" fromDictName:@"wallet"];
    [self setupForDismissKeyboard];
    [self rootView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.rootView.nameTextField.text.length == 0) {
        [self.rootView.nameTextField becomeFirstResponder];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.rootView.nameTextField]) {
        [self.rootView.passwordTextField becomeFirstResponder];
    }else if([textField isEqual:self.rootView.passwordTextField]) {
        [self.rootView.rePasswordTextField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - 下一步(注册时间)
- (void)nextButtonAction{
    [self showTCHUDWithTitle:nil];
        ///  注册用户
        [self isNewUser];
        //        [self registerUser];

}


#pragma mark - 是否是新用户
- (void)isNewUser{
    [self.view endEditing:YES];
    WEAK(self)
    [TCLoginManager checkIsOldUserWithPhone:self.phone success:^(id result) {
        if ([[result valueForKey:@"result"] isEqualToString:@"success"]) {
            if ([[result valueForKey:@"userStatus"] isEqualToString:@"1"]) {
                /// 老用户去创建钱包
                [weakself loginAndGetUserInfo];
            }else{
                /// 新用户去注册用户
                [weakself registerUser];
            }
        }else{
            [weakself hiddenTCHUD];
            [weakself showSystemAlertWithTitle:@"提示" message:@"请求失败"];
        }
    } fail:^(NSString *errorDescription) {
        Log(@"验证手机号是否是老用户 -- %@", errorDescription);
        [weakself hiddenTCHUD];
        [weakself showSystemAlertWithTitle:@"提示" message:@"请求失败"];
    }];
}

#pragma mark - 注册用户
- (void)registerUser{
    WEAK(self)
    [TCLoginManager registerNewUserWithPhone:self.phone nickName:self.rootView.nameTextField.text password:self.rootView.passwordTextField.text inviteCode:self.inviteCode planetEnName:self.planetEnName success:^(id result) {
        if ([[result valueForKey:@"result"] isEqualToString:@"success"]) {
            /// 登录获取用户信息
            [weakself loginAndGetUserInfo];
        }else{
            [weakself hiddenTCHUD];
            [weakself showSystemAlertWithTitle:@"提示" message:@"注册用户失败"];
        }
    } fail:^(NSString *errorDescription) {
        Log(@"注册失败 -- %@", errorDescription);
        [weakself hiddenTCHUD];
        [weakself showSystemAlertWithTitle:@"提示" message:@"请求失败"];
    }];
}

#pragma mark - 登录并获取用户信息
- (void)loginAndGetUserInfo{
    WEAK(self)
    [TCLoginManager loginWithPhone:self.phone password:self.rootView.passwordTextField.text success:^(id result) {
        /// 去创建钱包
        [weakself goCreateWalletOrBackUpWallet];
    } fail:^(NSString *errorDescription) {
        [weakself hiddenTCHUD];
        [weakself showSystemAlertWithTitle:@"提示" message:@"请求失败"];
    }];
}

#pragma mark - 去创建钱包
- (void)goCreateWalletOrBackUpWallet{
    [self hiddenTCHUD];
    TCWalletTipController *nextVc = [TCWalletTipController new];
    nextVc.password = self.rootView.passwordTextField.text;
    nextVc.phone = self.phone;
    nextVc.type = WalletTypeRegister;
    [self.navigationController pushViewController:nextVc animated:YES];
}


#pragma mark - 文本框内容变化时
- (void)textChange:(id)sender{
    BOOL isNextButtonEnabled = (self.rootView.passwordTextField.text.length >= 8 && [self.rootView.passwordTextField.text isEqualToString:self.rootView.rePasswordTextField.text] && self.rootView.isAgreePrivateView.isAgree);
    self.rootView.nextButton.enabled = isNextButtonEnabled;
    self.rootView.nextButton.alpha= isNextButtonEnabled?1:0.4;
}


#pragma mark - 查看协议
- (void)seeAgreementAction{
    TCPrivateController *privateVc = [TCPrivateController new];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:privateVc];
    nvc.navigationBar.theme_barStyle = [NSString theme_stringForKey:@"barStyle" fromDictName:@"navigationBar"];
    nvc.navigationBar.theme_tintColor = [UIColor theme_navigationBarColorPickerForKey:@"tintColor"];
    nvc.navigationBar.theme_barTintColor = [UIColor theme_navigationBarColorPickerForKey:@"barTintColor"];
    nvc.navigationBar.translucent = NO;
    [self presentViewController:nvc animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyload
- (TCRegisterView *)rootView{
    if (!_rootView) {
        _rootView = [TCRegisterView new];
        _rootView.tipLabel.text = @"密码用于登录、保护私钥和交易授权，强度非常重要。系统不存储密码，也无法帮您找回，请务必牢记！";
        [_rootView.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        _rootView.nameTextField.theme_attributePlaceHolder = [NSAttributedString theme_attributeStringWithString:@"用户昵称" attributeColor:[UIColor theme_colorPickerForKey:@"textFieldPlaceHolderColor" fromDictName:@"login"]];
        _rootView.passwordTextField.theme_attributePlaceHolder = [NSAttributedString theme_attributeStringWithString:@"密码(必须大于8位字符)" attributeColor:[UIColor theme_colorPickerForKey:@"textFieldPlaceHolderColor" fromDictName:@"login"]];
        _rootView.rePasswordTextField.theme_attributePlaceHolder = [NSAttributedString theme_attributeStringWithString:@"确认密码" attributeColor:[UIColor theme_colorPickerForKey:@"textFieldPlaceHolderColor" fromDictName:@"login"]];

        _rootView.nameTextField.delegate = self;
        _rootView.passwordTextField.delegate = self;
        _rootView.rePasswordTextField.delegate = self;
        [_rootView.passwordTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        [_rootView.rePasswordTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        [self textChange: nil];
        [_rootView.nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];

        WEAK(self)
        _rootView.isAgreePrivateView.agreementButtonActionBlock = ^{
            [weakself seeAgreementAction];
        };
        _rootView.isAgreePrivateView.agreeAgreementButtonActionBlock = ^{
            [weakself textChange:nil];
        };

        [self.view addSubview:_rootView];
        [_rootView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view);
            }
        }];
    }
    return _rootView;
}

@end
