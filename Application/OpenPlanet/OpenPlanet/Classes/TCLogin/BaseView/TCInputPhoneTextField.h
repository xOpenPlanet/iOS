//
//  TCInputPhoneTextField.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/23.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCInputPhoneTextField : UIView

/// 手机号
@property (strong, nonatomic) UITextField *phoneTextField;
/// 手机号区号按钮
@property (strong, nonatomic) UIButton *phoneAreaCodeButton;

@end
