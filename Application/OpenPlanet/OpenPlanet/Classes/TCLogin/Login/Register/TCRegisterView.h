//
//  TCRegisterView.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/28.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkChainHeader.h"
#import "TCWalletTextField.h"
#import "TCIsAgreePrivatePolicyView.h"
#import "EdgeInsetLabel.h"

@interface TCRegisterView : UIView

/// 警告文本
@property (strong, nonatomic) EdgeInsetLabel *tipLabel;
/// 钱包名称
@property (strong, nonatomic) TCWalletTextField *nameTextField;
/// 钱包密码
@property (strong, nonatomic) TCWalletTextField *passwordTextField;
/// 确认密码
@property (strong, nonatomic) TCWalletTextField *rePasswordTextField;
/// 是否同意协议
@property (strong, nonatomic) TCIsAgreePrivatePolicyView *isAgreePrivateView;
/// 下一步按钮
@property (strong, nonatomic) UIButton *nextButton;

@end
