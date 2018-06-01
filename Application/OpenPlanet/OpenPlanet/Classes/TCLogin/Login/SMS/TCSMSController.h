//
//  TCSMSController.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/10.
//  Copyright © 2018年 wsl. All rights reserved.
//  验证码控制器(支持注册、验证码登录、验证码修改密码三种模式)
//  注册：3.校验验证码
//  登录：3.验证码登录

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /// 注册
    TCSMSTypeRegister = 0,
    /// 验证码登录
    TCSMSTypeLogin,
    /// 忘记密码
    TCSMSTypeForgetPassword
} TCSMSType;


@interface TCSMSController : UIViewController

/// 控制器类型
@property (assign, nonatomic) TCSMSType type;
/// 地区编号
@property (copy, nonatomic) NSString *areaCode;
/// 手机号
@property (copy, nonatomic) NSString *phone;
/// 邀请码
@property (copy, nonatomic) NSString *inviteCode;
/// 星球英文名
@property (copy, nonatomic) NSString *planetEnName;

@end
