//
//  TCInputPasswordController.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/10.
//  Copyright © 2018年 wsl. All rights reserved.
//  2.密码登录(老用户)

#import <UIKit/UIKit.h>

@interface TCInputPasswordController : UIViewController

/// 地区编号
@property (copy, nonatomic) NSString *areaCode;
/// 手机号
@property (copy, nonatomic) NSString *phone;

@end
