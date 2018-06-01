//
//  TCBackUpMemoryWordController.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/9.
//  Copyright © 2018年 wsl. All rights reserved.
//  备份助记词控制器

#import <UIKit/UIKit.h>
#import <ethers/Account.h>
#import "TCWalletTipController.h"

@interface TCBackUpMemoryWordController : UIViewController

/// 是否已经登录成功
@property (assign, nonatomic) WalletType type;
/// 密码
@property (copy, nonatomic) NSString *password;
/// 手机号
@property (strong, nonatomic) NSString *phone;
/// 钱包账户
@property (strong, nonatomic) Account *account;

@end
