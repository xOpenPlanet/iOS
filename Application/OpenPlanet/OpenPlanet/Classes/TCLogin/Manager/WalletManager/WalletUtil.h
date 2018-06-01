//
//  WalletOther.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/22.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ethers/Wallet.h>
#import <ethers/WalletManager.h>
#import <ethers/CloudKeychainSigner.h>

#define WalletUtilObject [WalletUtil shared]

@interface WalletUtil : NSObject

/// 单例
+ (instancetype)shared;
/// 钱包密码
@property (strong, nonatomic) NSString *walletPassword;







/// 保存钱包图片
+ (void)saveWalletAccountImage:(UIImage *)image imageName:(NSString *)imageName;
/// 获取钱包图片
+ (UIImage *)getWalletAccountImageWithImageName:(NSString *)imageName;
/// 获取当前钱包，如果为nil则本地没有该钱包
+ (CloudKeychainSigner *)getCurrentWallet;
/// 保存通讯公钥和通讯私钥
+ (void)saveComPublicKey:(NSString *)comPublicKey comPrivateKey:(NSString *)comPrivateKey;
/// 获取通讯公钥
+ (NSString *)comPublicKey;
/// 获取通讯私钥
+ (NSString *)comPrivateKey;
/// 获取通讯公钥Key
+ (NSString *)comPublicKeyName;
/// 获取通讯私钥Key
+ (NSString *)comPrivateKeyName;
/// 兼容旧版本没有通讯私钥字段
+ (void)compatibleComPrivateKey;

@end
