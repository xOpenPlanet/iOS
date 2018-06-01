//
//  EnvironmentVariable.h
//  ESPTablet
//
//  Created by Javor on 14-8-9.
//  Copyright (c) 2014年 Javor. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPlatformMobile @"kPlatformMobile"
#define kPlatformTablet @"kPlatformTablet"

@interface EnvironmentVariable : NSObject

///用户输入的用户名
+(NSString *)getUser;
///用户名
+(NSString *)getUserName;
///邮箱
+(NSString *)getEmail;
///用户ID
+(NSString *)getUserID;
///钱包用户名
+(NSString *)getWalletUserID;
///密码
+(NSString *)getPassWord;
///邮箱加密
+(NSString *)getMD5Email;
///用户ID加密
+(NSString *)getMD5UserID;
///密码加密
+(NSString *)getMD5PassWord;
///加密
+(NSString *)getMD5;
///im用户ID
+(NSString *)getIMUserID;
///im用户密码
+(NSString *)getIMPassword;
///设备平台 手机 平板
+(NSString *)getPlatform;
///记录菜单选中项
+(NSString *)getMenuSelectedID;
///推送的token
+(NSString *)getDeviceToken;
///获取服务器的url
+(NSString *)getServerURL;
///获取version路径
+(NSString *)getVersionPath;
///获取用户钱包地址
+(NSString *)getWalletAddressWithUserID:(NSString *)userID;
///获取用户钱包MD5加密后的密码
+(NSString *)getWalletPasswordWithUserID:(NSString *)userID;
///其他变量
+(id)getPropertyForKey:(NSString *)key WithDefaultValue:(NSString *)defValue;

+(void)setUser:(NSString *)user;
+(void)setUserName:(NSString *)userName;
+(void)setEmail:(NSString *)email;
+(void)setUserID:(NSString *)userID;
+(void)setWalletUserID:(NSString *)userID;
+(void)setMD5PassWord:(NSString *)passWord;
+(void)setMD5Email:(NSString *)email;
+(void)setMD5UserID:(NSString *)userID;
+(void)setMD5:(NSString *)md5;
+(void)setIMUserID:(NSString *)imUserID;
+(void)setIMPassword:(NSString *)imPassword;
+(void)setPassWord:(NSString *)passWord;
+(void)setPlatform:(NSString *)platform;
+(void)setMenuSelectedID:(NSString *)selectedID;
+(void)setDeviceToken:(NSString *)token;
+(void)setServerURL:(NSString *)url;
+(void)setVersionPath:(NSString *)path;
+(void)setWalletUserID:(NSString *)userID password:(NSString *)password;
+(void)setWalletUserID:(NSString *)userID address:(NSString *)address;
+(void)setProperty:(id)property forKey:(NSString *)key;
+(void)setUnPersistenceProperty:(id)property forKey:(NSString *)key;
+(void)removePropertyForKey:(NSString *)key;

@end

