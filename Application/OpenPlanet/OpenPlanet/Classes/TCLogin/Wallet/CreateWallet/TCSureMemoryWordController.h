//
//  TCSureMemoryWordController.h
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/26.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ethers/Account.h>
#import "TCWalletTipController.h"

@interface TCSureMemoryWordController : UIViewController
/// 手机号
@property (strong, nonatomic) NSString *phone;
/// 密码
@property (copy, nonatomic) NSString *password;
/// 助记词
@property (strong, nonatomic) NSArray *memoryWord;
/// 是否已经登录成功
@property (assign, nonatomic) WalletType type;
/// 钱包账户
@property (strong, nonatomic) Account *account;

@end
