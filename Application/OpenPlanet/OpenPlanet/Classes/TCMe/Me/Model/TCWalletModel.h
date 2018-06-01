//
//  TCMeWalletModel.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/22.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ethers/CloudKeychainSigner.h>

@interface TCWalletModel : NSObject

/// 账户图片
@property (strong, nonatomic) UIImage *accountImage;
/// 交易右边图片
@property (strong, nonatomic) UIImage *transMiRightImage;
/// 能量币标题
@property (copy, nonatomic) NSString *energyCoinTitle;
/// 能量币余额
@property (copy, nonatomic) NSString *energyCoinBalance;
/// 账户
@property (copy, nonatomic) NSString *account;
/// 账户余额
@property (copy, nonatomic) NSString *accountBalance;

/// 籴米图片
@property (strong, nonatomic) UIImage *inMiImage;
/// 籴米标题
@property (copy, nonatomic) NSString *inMiTitle;
/// 粜米图片
@property (strong, nonatomic) UIImage *outMiImage;
/// 粜米标题
@property (copy, nonatomic) NSString *outMiTitle;

/// 交易米图片
@property (strong, nonatomic) UIImage *transMiImage;
/// 交易米标题
@property (copy, nonatomic) NSString *transMiTitle;


/// 钱包内容
@property (strong, nonatomic) CloudKeychainSigner *signer;

@end
