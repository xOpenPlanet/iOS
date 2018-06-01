//
//  TCInputPasswordController.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/10.
//  Copyright © 2018年 wsl. All rights reserved.
//  2.密码登录(老用户)

#import "TCInputPasswordController.h"
#import "TCLoginBaseView.h"
#import "TCInputPhoneTextField.h"
#import "TCSMSTextField.h"
#import "TCSMSController.h"
#import "TCRegisterController.h"
#import "TCWalletTipController.h"
#import "AppDelegate.h"

@interface TCInputPasswordController ()<UITextFieldDelegate>

@property (strong, nonatomic) TCLoginBaseView *rootView;
@property (strong, nonatomic) TCInputPhoneTextField *inputPhoneTextField;
@property (strong, nonatomic) TCSMSTextField *passwordTextField;
@property (strong, nonatomic) UIButton *otherButton;


@end

@implementation TCInputPasswordController

/// 分离业务和布局(替换主View)
- (void)loadView{
    self.view = self.rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForDismissKeyboard];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.passwordTextField.SMSTextField becomeFirstResponder];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}



#pragma mark - 文本框内容变化时
- (void)textChanged{
    BOOL isTextFieldEmpty = (self.passwordTextField.SMSTextField.text.length == 0);
    self.rootView.nextButton.enabled = !isTextFieldEmpty;
    self.rootView.nextButton.alpha= isTextFieldEmpty?0.4:1;
}

#pragma mark - 下一步按钮事件
- (void)nextButtonAction:(UIButton *)sender{
    [self.view endEditing:YES];
    [self showTCHUDWithTitle:@"正在登录"];
    WEAK(self)
    [TCLoginManager loginWithPhone:self.phone password:self.passwordTextField.SMSTextField.text success:^(id result) {
        [weakself hiddenTCHUD];
        
        NSDictionary *userInfo = [result valueForKey:@"userInfo"];
        NSString *walletAddress = [userInfo valueForKey:@"ethAddress"];
        /// 存储登录用户的钱包地址
        [EnvironmentVariable setProperty:walletAddress forKey:@"loginWalletAddress"];
        
        if (StringIsEmpty(walletAddress)) {
            TCWalletTipController *nextVc = [TCWalletTipController new];
            nextVc.phone = self.phone;
            nextVc.password = self.passwordTextField.SMSTextField.text;
            nextVc.type = WalletTypeLogin;
            [self.navigationController pushViewController:nextVc animated:YES];
        }else{
            
            NSString *localWalletAddress = [EnvironmentVariable getWalletAddressWithUserID:[EnvironmentVariable getWalletUserID]];
            
            if (![walletAddress hasPrefix:@"0x"]) {
                walletAddress = [@"0x" stringByAppendingString:walletAddress];
            }
            
            // 本地有钱包并且和服务器钱包一致，进主界面，否则创建
            BOOL isNotNeedCreateWallet = ![localWalletAddress isEqualToString:@""] && [[localWalletAddress uppercaseString] isEqualToString:[walletAddress uppercaseString]];
            if (isNotNeedCreateWallet) {
                [EnvironmentVariable setProperty:@(LoginStepLoginSuccess) forKey:LOGIN_STEP];
                // 登录成功切换主控制器
                [(AppDelegate *)APPDELEGATE goMainView];
            }else{
                TCWalletTipController *nextVc = [TCWalletTipController new];
                nextVc.phone = self.phone;
                nextVc.password = self.passwordTextField.SMSTextField.text;
                nextVc.type = WalletTypeLoginBackUp;
                [self.navigationController pushViewController:nextVc animated:YES];
            }
        }
        
        
    } fail:^(NSString *errorDescription) {
        [weakself hiddenTCHUD];
        [weakself showSystemAlertWithTitle:@"提示" message:@"登录失败"];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (self.passwordTextField.SMSTextField.text.length > 0) {
        [self nextButtonAction:self.rootView.nextButton];
    }
    return YES;
}

#pragma mark - 返回
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)otherButtonAction{
    [self.view endEditing:YES];
    TCSMSController *vc = [TCSMSController new];
    vc.areaCode = self.areaCode;
    vc.phone = self.phone;
    vc.type = TCSMSTypeLogin;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyload
- (TCLoginBaseView *)rootView{
    if (!_rootView) {
        _rootView = [TCLoginBaseView new];
        /// 设置控件默认值
        _rootView.topBgImageView.theme_image = [UIImage theme_bundleImageNamed:@"login/login_pwd_bg.png"];
        _rootView.tipImageView.theme_image = [UIImage theme_bundleImageNamed:@"login/login_pwd.png"];
        _rootView.titleLabel.text = @"输入密码登录";
        [_rootView.nextButton setTitle:@"登录" forState:UIControlStateNormal];
        [_rootView.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_rootView.nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        /// 移除提示Label,节省空间
        [_rootView.tipLabel removeFromSuperview];
        
        
        [_rootView.customView addSubview:self.inputPhoneTextField];
        [self.inputPhoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_rootView.customView);
            make.height.equalTo(@45);
        }];
        
        [_rootView.customView addSubview:self.passwordTextField];
        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inputPhoneTextField.mas_bottom).offset(5);
            make.left.right.equalTo(self.inputPhoneTextField);
        }];
        
        [_rootView.customView addSubview:self.otherButton];
        [self.otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordTextField.mas_bottom).offset(5);
            make.left.bottom.equalTo(_rootView.customView);
        }];
    }
    return _rootView;
}

- (TCInputPhoneTextField *)inputPhoneTextField{
    if (!_inputPhoneTextField) {
        _inputPhoneTextField = [TCInputPhoneTextField new];
        _inputPhoneTextField.phoneTextField.theme_attributePlaceHolder = [NSAttributedString theme_attributeStringWithString:@"请输入手机号"attributeColor:[UIColor theme_colorPickerForKey:@"textFieldPlaceHolderColor" fromDictName:@"login"]];
        _inputPhoneTextField.phoneTextField.text = self.phone;
        [_inputPhoneTextField.phoneAreaCodeButton setTitle:self.areaCode forState:UIControlStateNormal];
        [_inputPhoneTextField.phoneAreaCodeButton setTitleColor:cLightGrayColor forState:UIControlStateNormal];
        _inputPhoneTextField.phoneTextField.textColor = cLightGrayColor;
        _inputPhoneTextField.phoneTextField.enabled = NO;
        
    }
    return _inputPhoneTextField;
}

- (TCSMSTextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [TCSMSTextField new];
        _passwordTextField.SMSTextField.delegate = self;
        _passwordTextField.SMSTextField.theme_attributePlaceHolder = [NSAttributedString theme_attributeStringWithString:@"请输入密码"attributeColor:[UIColor theme_colorPickerForKey:@"textFieldPlaceHolderColor" fromDictName:@"login"]];
        
        [_passwordTextField.SMSTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
        _passwordTextField.SMSTextField.secureTextEntry = YES;
        _passwordTextField.SMSTextField.returnKeyType = UIReturnKeyDone;
        _passwordTextField.SMSTextField.keyboardType = UIKeyboardTypeDefault;
        _passwordTextField.SMSTextField.rightViewMode = UITextFieldViewModeNever;
        /// 设置下一步按钮默认状态
        [self textChanged];
    }
    return _passwordTextField;
}

- (UIButton *)otherButton{
    if (!_otherButton) {
        _otherButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _otherButton.tintColor = TCThemeColor;
        [_otherButton setTitle:@"使用短信验证码登录" forState:UIControlStateNormal];
        [_otherButton addTarget:self action:@selector(otherButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherButton;
}
@end
