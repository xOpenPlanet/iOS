//
//  TCImportWalletController.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/12.
//  Copyright © 2018年 wsl. All rights reserved.
//  导入钱包控制器

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /// 注册添加或恢复钱包
    WalletTypeRegister,
    /// 登录成功(本地没有钱包,服务器没钱包) 能创建或者恢复
    WalletTypeLogin,
    /// 登录成功(本地没有钱包，服务器有钱包) 只能恢复
    WalletTypeLoginBackUp,
    /// 系统内部添加钱包
    WalletTypeAdd,
} WalletType;


@interface TCWalletTipController : UIViewController

/// 钱包
@property (assign, nonatomic) WalletType type;
/// 手机号
@property (copy, nonatomic) NSString *phone;
/// 密码
@property (copy, nonatomic) NSString *password;

@end
