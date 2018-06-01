//
//  TCLoginManager.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/12.
//  Copyright © 2018年 wsl. All rights reserved.
//  淘米链登录管理器

#import <Foundation/Foundation.h>
#import "TalkChainHeader.h"


@interface TCLoginManager : NSObject

#pragma mark - 检查用户是新用户还是老用户
/**
 检查是新用户还是老用户(通过手机号)

 @param phone 手机号
 */
+ (void)checkIsOldUserWithPhone:(NSString *)phone
                        success:(SuccessBlock)success
                           fail:(FailBlock)fail;


#pragma mark - 获取验证码
/**
 获取验证码

 @param phone 手机号
 */
+ (void)getSMSWithPhone:(NSString *)phone
                success:(SuccessBlock)success
                   fail:(FailBlock)fail;

#pragma mark - 校验验证码
/**
 校验验证码

 @param phone 手机号
 @param code 验证码
 */
+ (void)checkSMSWithPhone:(NSString *)phone
                     code:(NSString *)code
                  success:(SuccessBlock)success
                     fail:(FailBlock)fail;

#pragma mark - 注册新用户
/**
 注册新用户

 @param phone 手机号
 @param nickName 昵称
 @param password 密码
 @param inviteCode 邀请码
 @param planetEnName 星球英文名
 */
+ (void)registerNewUserWithPhone:(NSString *)phone
                        nickName:(NSString *)nickName
                        password:(NSString *)password
                      inviteCode:(NSString *)inviteCode
                    planetEnName:(NSString *)planetEnName
                         success:(SuccessBlock)success
                            fail:(FailBlock)fail;


#pragma mark - 登录
/**
 登录

 @param phone 手机号
 @param password 密码
 */
+ (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
               success:(SuccessBlock)success
                  fail:(FailBlock)fail;




#pragma mark - 验证码登录
/**
 验证码登录

 @param phone 手机号
 @param smsCode 验证码
 */
+(void)SMSLoginWithPhone:(NSString *)phone
                smsCode:(NSString *)smsCode
                 success:(SuccessBlock)success
                    fail:(FailBlock)fail;


#pragma mark - 获取用户信息
/// 根据Token获取用户信息
+ (void)getUserInfoWithSuccess:(SuccessBlock)success
                              fail:(FailBlock)fail;


#pragma mark - 同步通讯录
/**
 同步粉丝

 @param peoples 通讯录联系人
 */
+ (void)uploadFansWithFans:(NSArray *)peoples
                     progress:(FloatBlock)progress
                      success:(SuccessBlock)success
                         fail:(FailBlock)fail;



#pragma mark - 获取通讯录
/// 获取通讯录
+ (void)loadPeopleWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;



#pragma mark - 保存钱包地址和公钥
/**
 保存钱包地址和公钥

 @param walletAddress 钱包地址
 @param publicKey 钱包公钥
 */
+ (void)saveWalletWithWalletAddress:(NSString *)walletAddress
                          publicKey:(NSString *)publicKey
                       comPublicKey:(NSString *)comPublieKey
                            success:(SuccessBlock)success fail:(FailBlock)fail;


#pragma mark - 更新通讯公钥

/// 更新通讯公钥
+ (void)updateComPublicKey:(NSString *)comPublicKey success:(SuccessBlock)success fail:(FailBlock)fail;




/**
 验证邀请码

 @param inviteCode 邀请码
 */
+ (void)checkInviteCodeWithInviteCode:(NSString *)inviteCode
                              success:(SuccessBlock)success
                                 fail:(FailBlock)fail;
@end

