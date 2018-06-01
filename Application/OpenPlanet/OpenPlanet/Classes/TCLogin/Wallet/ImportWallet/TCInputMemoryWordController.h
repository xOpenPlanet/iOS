//
//  TCInputMemoryWordController.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/14.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCWalletTipController.h"

@interface TCInputMemoryWordController : UIViewController

/// 是否已经登录成功
@property (assign, nonatomic) WalletType type;
/// 手机号
@property (copy, nonatomic) NSString *phone;
/// 密码
@property (copy, nonatomic) NSString *password;

@end
