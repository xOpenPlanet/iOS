//
//  TCSMSTextField.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/23.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCSMSTextField : UIView

/// 短信验证码输入框
@property (strong, nonatomic) UITextField *SMSTextField;
/// 获取短信验证码按钮
@property (strong, nonatomic) UIButton *SMSButton;

@end
