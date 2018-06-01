//
//  TCPhoneController.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/10.
//  Copyright © 2018年 wsl. All rights reserved.
//  1.输入手机号

#import "TCInputPhoneController.h"
#import "TCLoginBaseView.h"
#import "TCInputPhoneTextField.h"
#import "TCLoginManager.h"
#import "TCInputPasswordController.h"
#import "TCInputInviteCodeController.h"
#import "TCChosePlanetController.h"
#import "ThemeKit.h"
#import "UIViewController+TCHUD.h"

@interface TCInputPhoneController ()

@property (strong, nonatomic) TCLoginBaseView *rootView;
@property (strong, nonatomic) TCInputPhoneTextField *inputPhoneTextField;

@end

@implementation TCInputPhoneController

/// 分离业务和布局(替换主View)
- (void)loadView{
    self.view = self.rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForDismissKeyboard];

    /// 如果有旧账户,自动显示用户名
    NSString *phone = [EnvironmentVariable getWalletUserID];
    if (!StringIsEmpty(phone)) {
        self.inputPhoneTextField.phoneTextField.text = phone;
        [self textChanged];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.inputPhoneTextField.phoneTextField.text.length == 0) {
        [self.inputPhoneTextField.phoneTextField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - 文本框内容变化时
- (void)textChanged{
    /// 判断手机号是否为空
    BOOL isPhoneRight = (self.inputPhoneTextField.phoneTextField.text.length == 11);
    self.rootView.nextButton.enabled = isPhoneRight;
    self.rootView.nextButton.alpha= isPhoneRight?1:0.4;
}

#pragma mark - 下一步按钮事件
- (void)nextButtonAction:(UIButton *)sender{
    [self.view endEditing:YES];
    WEAK(self)
    [self showTCHUDWithTitle:@"请稍候..."];
    [TCLoginManager checkIsOldUserWithPhone:self.inputPhoneTextField.phoneTextField.text success:^(id result) {
        [weakself hiddenTCHUD];
        if ([[result valueForKey:@"result"] isEqualToString:@"success"]) {
            if ([[result valueForKey:@"userStatus"] isEqualToString:@"1"]) {
                // 老用户密码登录
                TCInputPasswordController *vc = [TCInputPasswordController new];
                vc.areaCode = weakself.inputPhoneTextField.phoneAreaCodeButton.titleLabel.text;
                vc.phone = weakself.inputPhoneTextField.phoneTextField.text;
                [weakself.navigationController pushViewController:vc animated:YES];
            }else if([[result valueForKey:@"userStatus"] isEqualToString:@"0"]){
                // 新用户
                TCInputInviteCodeController *vc = [TCInputInviteCodeController new];
                vc.areaCode = weakself.inputPhoneTextField.phoneAreaCodeButton.titleLabel.text;
                vc.phone = weakself.inputPhoneTextField.phoneTextField.text;
                [weakself.navigationController pushViewController:vc animated:YES];
            }else if([[result valueForKey:@"userStatus"] isEqualToString:@"-1"]){
                // 白名单新用户，不需要邀请码
                TCChosePlanetController *vc = [TCChosePlanetController new];
                vc.areaCode = weakself.inputPhoneTextField.phoneAreaCodeButton.titleLabel.text;
                vc.phone = weakself.inputPhoneTextField.phoneTextField.text;
                vc.inviteCode = @"";
                [weakself.navigationController pushViewController:vc animated:YES];
            }
        }else{
            [weakself showSystemAlertWithTitle:@"提示" message:@"验证失败"];
        }
    } fail:^(NSString *errorDescription) {
        Log(@"验证手机号是否是老用户 -- %@", errorDescription);
        [weakself hiddenTCHUD];
        [weakself showSystemAlertWithTitle:@"提示" message:@"请求失败"];
    }];
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
        _rootView.titleLabel.text = @"欢迎使用开放星球";
        _rootView.tipLabel.text = @"为方便给您提供更优质的服务，请输入您的手机号";
        [_rootView.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_rootView.nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rootView.customView addSubview:self.inputPhoneTextField];
        [self.inputPhoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_rootView.customView);
        }];
    }
    return _rootView;
}

- (TCInputPhoneTextField *)inputPhoneTextField{
    if (!_inputPhoneTextField) {
        _inputPhoneTextField = [TCInputPhoneTextField new];
        _inputPhoneTextField.phoneTextField.theme_attributePlaceHolder = [NSAttributedString theme_attributeStringWithString:@"请输入手机号"attributeColor:[UIColor theme_colorPickerForKey:@"textFieldPlaceHolderColor" fromDictName:@"login"]];
        [_inputPhoneTextField.phoneAreaCodeButton setTitle:@"+86" forState:UIControlStateNormal];
        [_inputPhoneTextField.phoneTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
        /// 设置下一步按钮默认状态
        [self textChanged];
    }
    return _inputPhoneTextField;
}


@end
