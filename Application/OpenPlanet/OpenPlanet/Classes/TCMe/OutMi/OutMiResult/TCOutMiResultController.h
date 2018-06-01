//
//  TCTransderSuccessController.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/23.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//  转账成功

#import <UIKit/UIKit.h>
#import "TCOutMiController.h"

@interface TCOutMiResultController : UIViewController

/// 钱包账户
@property (copy, nonatomic) NSString *fromWalletAddress;
@property (strong, nonatomic)  CloudKeychainSigner *signer;

@property (copy, nonatomic) NSString *toPhone;
@property (copy, nonatomic) NSString *toAddress;
@property (copy, nonatomic) NSString *moneyValue;
@property (copy, nonatomic) NSString *password;

@property (strong, nonatomic) UIViewController *fromVc;
/// 进入类型
@property (assign, nonatomic) TransferFromType type;



@end
