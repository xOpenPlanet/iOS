//
//  TCInputInviteCodeController.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/22.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//  2.输入邀请码(新用户)

#import "TCInputInviteCodeController.h"
#import "TCLoginBaseView.h"
#import "TCSMSTextField.h"
#import "TCSMSController.h"
#import "TCLoginManager.h"
#import "TCChosePlanetController.h"

@interface TCInputInviteCodeController ()<UITextFieldDelegate>

@property (strong, nonatomic) TCLoginBaseView *rootView;
@property (strong, nonatomic) TCSMSTextField *inviteCodeTextField;

@end

@implementation TCInputInviteCodeController

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
    if (self.inviteCodeTextField.SMSTextField.text.length == 0) {
        [self.inviteCodeTextField.SMSTextField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - 返回
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 文本框内容变化时
- (void)textChanged{
    /// 判断手机号是否为空
    BOOL isPhoneRight = (self.inviteCodeTextField.SMSTextField.text.length != 0);
    self.rootView.nextButton.enabled = isPhoneRight;
    self.rootView.nextButton.alpha= isPhoneRight?1:0.4;
}

#pragma mark - 下一步按钮事件
- (void)nextButtonAction:(UIButton *)sender{
    [self.view endEditing:YES];
    WEAK(self)
    [self showTCHUDWithTitle:@"正在校验邀请码"];
    [TCLoginManager checkInviteCodeWithInviteCode:self.inviteCodeTextField.SMSTextField.text success:^(id result) {
        [weakself hiddenTCHUD];
        if ([[result valueForKey:@"result"] isEqualToString:@"success"]) {
            NSString *code = [NSString stringWithFormat:@"%@",[result valueForKey:@"inviteCodeAvailabilityCount"]];
            if ([code isEqualToString:@"-1"]) {
                [weakself showSystemAlertWithTitle:@"提示" message:@"邀请码不存在"];
            }else{
                TCChosePlanetController *vc = [TCChosePlanetController new];
                vc.areaCode = weakself.areaCode;
                vc.phone = weakself.phone;
                vc.inviteCode = weakself.inviteCodeTextField.SMSTextField.text;
                [weakself.navigationController pushViewController:vc animated:YES];
            }
        }else{
            [weakself showSystemAlertWithTitle:@"提示" message:@"验证邀请码失败"];
        }
    } fail:^(NSString *errorDescription) {
        [weakself hiddenTCHUD];
        [weakself showSystemAlertWithTitle:@"提示" message:@"请求失败"];
    }];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (self.inviteCodeTextField.SMSTextField.text.length > 0) {
        [self nextButtonAction:self.rootView.nextButton];
    }
    return YES;
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
        _rootView.titleLabel.text = @"输入邀请码";
        [_rootView.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_rootView.nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rootView.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        /// 移除提示Label,节省空间
        _rootView.tipLabel.text = @"";
        [_rootView.tipLabel removeFromSuperview];
        
        [_rootView.customView addSubview:self.inviteCodeTextField];
        [self.inviteCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_rootView.customView);
        }];
        
    }
    return _rootView;
}

- (TCSMSTextField *)inviteCodeTextField{
    if (!_inviteCodeTextField) {
        _inviteCodeTextField = [TCSMSTextField new];
        _inviteCodeTextField.SMSTextField.delegate = self;
        _inviteCodeTextField.SMSTextField.theme_attributePlaceHolder = [NSAttributedString theme_attributeStringWithString:@"请输入邀请码" attributeColor:[UIColor theme_colorPickerForKey:@"textFieldPlaceHolderColor" fromDictName:@"login"]];
        [_inviteCodeTextField.SMSTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
        _inviteCodeTextField.SMSTextField.returnKeyType = UIReturnKeyDone;
        _inviteCodeTextField.SMSTextField.keyboardType = UIKeyboardTypeAlphabet;
        _inviteCodeTextField.SMSTextField.rightViewMode = UITextFieldViewModeNever;
        
        /// 设置下一步按钮默认状态
        [self textChanged];
    }
    return _inviteCodeTextField;
}

@end
