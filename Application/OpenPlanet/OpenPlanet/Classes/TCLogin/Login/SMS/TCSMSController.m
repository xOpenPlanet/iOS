//
//  TCSMSController.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/10.
//  Copyright © 2018年 wsl. All rights reserved.
//  验证码控制器(支持注册、验证码登录、验证码修改密码三种模式)
//  注册：3.校验验证码
//  登录：3.验证码登录

#import "TCSMSController.h"
#import "TCResetPasswordController.h"
#import "TCRegisterController.h"
#import "TCWalletTipController.h"
#import "TCLoginBaseView.h"
#import "TCSMSTextField.h"
#import "UIView+TCHUD.h"
#import "UIViewController+TCHUD.h"
#import "AppDelegate.h"

@interface TCSMSController ()<UITextFieldDelegate>

@property (strong, nonatomic) TCLoginBaseView *rootView;
@property (strong, nonatomic) TCSMSTextField *SMSTextField;
/// 验证码倒计时
@property (strong, nonatomic) dispatch_source_t timer;

@end

@implementation TCSMSController

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


#pragma mark - 发送验证码
- (void)sendSMS{
    WEAK(self)
    [TCLoginManager getSMSWithPhone:self.phone success:^(id result) {
        if ([[result valueForKey:@"result"] isEqualToString:@"success"]) {
            
        }else{
            [weakself closeTimer];
            [weakself showSystemAlertWithTitle:@"提示" message:@"发送验证码失败,请重试"];
        }
    } fail:^(NSString *errorDescription) {
        Log(@"获取验证码失败 -- %@", errorDescription);
        [weakself closeTimer];
        [weakself showSystemAlertWithTitle:@"提示" message:@"获取验证码失败"];
    }];
}

#pragma mark - 启动定时器
- (void)startTimer{
    /// 修改提示文本
    [self changeTipTitle];
    /// 倒计时总时长
    __block NSInteger time = 59;
    /// 1.获取默认线程
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    /// 2.创建类型为定时器类型的Dispatch Source,并将定时器设置在线程中
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    /// 3.设置定时器每秒执行一次
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    WEAK(self)
    /// 4.设置定时器需要执行的动作
    dispatch_source_set_event_handler(timer, ^{
        if(time <= 0){
            /// 倒计时结束，关闭
            [self closeTimer];
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                /// 设置按钮显示读秒效果
                [weakself.SMSTextField.SMSButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [weakself.SMSTextField.SMSButton setTitleColor:cGrayColor forState:UIControlStateNormal];
                weakself.SMSTextField.SMSButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    /// 5.启动定时器
    dispatch_resume(timer);
    self.timer = timer;
}

#pragma mark - 关闭定时器
- (void)closeTimer{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        WEAK(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            /// 设置按钮的样式
            [weakself.SMSTextField.SMSButton setTitle:@"重新发送" forState:UIControlStateNormal];
            [weakself.SMSTextField.SMSButton theme_setTitleColor:[UIColor theme_colorPickerForKey:@"tipColor"] forState:UIControlStateNormal];
            weakself.SMSTextField.SMSButton.userInteractionEnabled = YES;
        });
    }
    self.timer = nil;
}


#pragma mark - 文本框内容变化时
- (void)textChanged{
    /// 判断输入框是否为空
    BOOL isTextFieldEmpty = (self.SMSTextField.SMSTextField.text.length == 0);
    self.rootView.nextButton.enabled = !isTextFieldEmpty;
    self.rootView.nextButton.alpha= isTextFieldEmpty?0.4:1;
}

#pragma mark - 下一步按钮事件
- (void)nextButtonAction:(UIButton *)sender{
    [self.view endEditing:YES];
    WEAK(self)
    if (self.type == TCSMSTypeLogin) {
        // 验证码登录
        [self showTCHUDWithTitle:@"正在登录"];
        [TCLoginManager SMSLoginWithPhone:self.phone smsCode:self.SMSTextField.SMSTextField.text success:^(id result) {
            [weakself hiddenTCHUD];
            
            NSDictionary *userInfo = [result valueForKey:@"userInfo"];
            NSString *walletAddress = [userInfo valueForKey:@"ethAddress"];
            /// 存储登录用户的钱包地址
            [EnvironmentVariable setProperty:walletAddress forKey:@"loginWalletAddress"];
            
            if (StringIsEmpty(walletAddress)) {
                TCWalletTipController *nextVc = [TCWalletTipController new];
                nextVc.phone = self.phone;
                //                nextVc.password = self.SMSTextField.SMSTextField.text;
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
                    //                nextVc.password = self.SMSTextField.SMSTextField.text;
                    nextVc.type = WalletTypeLoginBackUp;
                    [self.navigationController pushViewController:nextVc animated:YES];
                }
            }
        } fail:^(NSString *errorDescription) {
            [weakself hiddenTCHUD];
            [weakself closeTimer];
            [weakself showSystemAlertWithTitle:@"提示" message:@"登录失败"];
        }];
        
    }else{
        [self showTCHUDWithTitle:nil];
        [TCLoginManager checkSMSWithPhone:self.phone code:self.SMSTextField.SMSTextField.text success:^(id result) {
            if ([[result valueForKey:@"result"] isEqualToString:@"success"]) {
                if (self.type == TCSMSTypeRegister) {
                    [weakself hiddenTCHUD];
                    TCRegisterController *createWalletVc = [TCRegisterController new];
                    createWalletVc.phone = weakself.phone;
                    createWalletVc.inviteCode = weakself.inviteCode;
                    createWalletVc.planetEnName = weakself.planetEnName;
                    [weakself.navigationController pushViewController:createWalletVc animated:YES];
                }else if(self.type == TCSMSTypeForgetPassword){
                    [weakself hiddenTCHUD];
                    TCResetPasswordController *newPasswordVc = [TCResetPasswordController new];
                    newPasswordVc.phone = self.phone;
                    newPasswordVc.areaCode = self.areaCode;
                    [self.navigationController pushViewController:newPasswordVc animated:YES];
                }
            }else{
                [weakself hiddenTCHUD];
                [weakself closeTimer];
                [weakself showSystemAlertWithTitle:@"提示" message:@"验证码校验失败"];
            }
        } fail:^(NSString *errorDescription) {
            Log(@"校验验证码失败 -- %@", errorDescription);
            [weakself hiddenTCHUD];
            [weakself closeTimer];
            [weakself showSystemAlertWithTitle:@"提示" message:@"请求失败"];
        }];
    }
    
    
}

#pragma mark - 返回
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)SMSButtonAction{
    [self.SMSTextField.SMSTextField becomeFirstResponder];
    /// 开启定时器
    [self startTimer];
    /// 请求发送验证码
    [self sendSMS];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    BOOL isTextFieldEmpty = (self.SMSTextField.SMSTextField.text.length == 0);
    if (!isTextFieldEmpty) {
        [self nextButtonAction:self.rootView.nextButton];
    }
    return YES;
}

#pragma mark - 修改提示文本(是否发送验证码)
- (void)changeTipTitle{
    NSString *tipText = [NSString stringWithFormat:@"已向 %@ %@ 发送了短信验证码",self.areaCode,self.phone];
    self.rootView.tipLabel.text = tipText;
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
        _rootView.topBgImageView.theme_image = [UIImage theme_bundleImageNamed:@"login/login_sms_bg.png"];
        _rootView.tipImageView.theme_image = [UIImage theme_bundleImageNamed:@"login/login_sms.png"];
        _rootView.tipLabel.text = [NSString stringWithFormat:@"通过点击“获取验证码”按钮，向 %@ %@ 发送短信验证码",self.areaCode,self.phone];
        NSString *title = (self.type == TCSMSTypeForgetPassword)?@"验证手机号":@"输入短信验证码";
        _rootView.titleLabel.text = title;
        NSString *nextTitle = (self.type == TCSMSTypeRegister) ? @"下一步" : @"登录";
        [_rootView.nextButton setTitle:nextTitle forState:UIControlStateNormal];
        
        [_rootView.nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rootView.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_rootView.customView addSubview:self.SMSTextField];
        [self.SMSTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_rootView.customView);
        }];
    }
    return _rootView;
}

- (TCSMSTextField *)SMSTextField{
    if (!_SMSTextField) {
        _SMSTextField = [TCSMSTextField new];
        _SMSTextField.SMSTextField.delegate = self;
        [_SMSTextField.SMSButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _SMSTextField.SMSTextField.theme_attributePlaceHolder = [NSAttributedString theme_attributeStringWithString:@"输入短信验证码" attributeColor:[UIColor theme_colorPickerForKey:@"textFieldPlaceHolderColor" fromDictName:@"login"]];
        _SMSTextField.SMSTextField.returnKeyType = UIReturnKeyDone;
        _SMSTextField.SMSTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_SMSTextField.SMSTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
        [_SMSTextField.SMSButton addTarget:self action:@selector(SMSButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        /// 设置下一步按钮默认状态
        [self textChanged];
    }
    return _SMSTextField;
}



@end
