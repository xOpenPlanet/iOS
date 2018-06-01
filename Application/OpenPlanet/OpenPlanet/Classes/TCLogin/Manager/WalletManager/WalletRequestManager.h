//
//  WalletRequestManager.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/20.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkChainHeader.h"
#import <ethers/CloudKeychainSigner.h>
#import <ethers/WalletManager.h>


@interface WalletRequestManager : NSObject


/**
 查询余额

 @param address 钱包地址
 */
+ (void)queryBalanceWithAddress:(NSString *)address
                        success:(SuccessBlock)success
                           fail:(FailBlock)fail;

/**
 查询多账户余额

 @param addresses 账户数组
 */
+ (void)queryBalancesWithAddresses:(NSArray <NSString *>*)addresses
                           success:(SuccessBlock)success
                              fail:(FailBlock)fail;


/**
 查询Nonce

 @param walletAddress 钱包地址
 */
+ (void)queryNonceWithWalletAddress:(NSString *)walletAddress
                            success:(SuccessBlock)success
                               fail:(FailBlock)fail;



/**
 转账

 @param fromPhone 自己账号
 @param toPhone 对方账号
 @param fromAddress 自己钱包地址
 @param toAddress 对方钱包地址
 @param signedTransaction 钱包签名
 @param value 钱数
 */
+ (void)transferMoneyWithFromPhone:(NSString *)fromPhone
                           toPhone:(NSString *)toPhone
                       fromAddress:(NSString *)fromAddress
                         toAddress:(NSString *)toAddress
                             value:(NSString *)value
                 signedTransaction:(NSString *)signedTransaction
                           success:(SuccessBlock)success
                              fail:(FailBlock)fail;

/**
 集成转账模块功能

 @param password 钱包密码
 @param toPhone 对方账号
 @param toAddress 对方钱包地址
 @param moneyValue 钱数
 */
+ (void)transferWithPasssword:(NSString *)password
                      toPhone:(NSString *)toPhone
                    toAddress:(NSString *)toAddress
                   moneyValue:(NSString *)moneyValue
                      success:(SuccessBlock)success
                         fail:(FailBlock)fail;


/**
 集成转账模块功能

 @param signer 需要转账的账户
 @param password 钱包密码
 @param toPhone 对方账号
 @param toAddress 对方钱包地址
 @param moneyValue 钱数
 */
+ (void)transferWithSigner:(CloudKeychainSigner *)signer
                passsword:(NSString *)password
                  toPhone:(NSString *)toPhone
                toAddress:(NSString *)toAddress
               moneyValue:(NSString *)moneyValue
                  success:(SuccessBlock)success
                     fail:(FailBlock)fail;


/// 获取银钻数
+ (void)getSilverDiamondNumWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;
@end
