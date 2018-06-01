//
//  TCPasswordController.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/14.
//  Copyright © 2018年 wsl. All rights reserved.
//  重置密码

#import <UIKit/UIKit.h>

@interface TCResetPasswordController : UIViewController

/// 地区编号
@property (copy, nonatomic) NSString *areaCode;
/// 手机号
@property (copy, nonatomic) NSString *phone;

@end
