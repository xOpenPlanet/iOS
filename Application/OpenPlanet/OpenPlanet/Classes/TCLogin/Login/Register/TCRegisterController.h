//
//  TCRegisterController.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/9.
//  Copyright © 2018年 wsl. All rights reserved.
//  4.注册安全账户

#import <UIKit/UIKit.h>

@interface TCRegisterController : UIViewController

/// 手机号
@property (copy, nonatomic) NSString *phone;
/// 邀请码
@property (copy, nonatomic) NSString *inviteCode;
/// 星球英文名
@property (copy, nonatomic) NSString *planetEnName;

@end
