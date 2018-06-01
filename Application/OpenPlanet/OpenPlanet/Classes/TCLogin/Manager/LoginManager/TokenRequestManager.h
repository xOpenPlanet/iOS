//
//  TokenRequestManager.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/19.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkChainHeader.h"

@class TCLoginManager;

#define kAccess_token          @"access_token"
#define kRefresh_token         @"refresh_token"
#define kExpires_in            @"expires_in"
#define client_id_value        @"a6f23fbb-0a1d-4e10-be7e-89181cdf089c" /// 临时写死
#define client_secret_value    @"2a6a9640-9a46-4622-b226-bc94b852848c" /// 临时写死


/// token请求类型
typedef enum : NSUInteger {
    /// 登录获取token
    TokenRequestTypeLogin,
    /// 验证码获取token
    TokenRequestTypeSMSLogin,
    /// 刷新token
    TokenRequestTypeRefresh
} TokenRequestType;

@interface TokenRequestManager : NSObject


/// 获取临时token
+ (NSString *)access_token;
/// 获取长时长token
+ (NSString *)refresh_token;


/**
 根据类型请求token

 @param type token请求类型
 @param params 变化的参数
 */
+ (void)tokenRequestWithType:(TokenRequestType)type changeParams:(NSDictionary *)params success:(SuccessBlock)success fail:(FailBlock)fail;


/// 判断token是否过期(token过期自动刷新token，刷新失败跳转登录页面)
+ (void)isTokenExpiredWithResponse:(NSDictionary *)response complete:(BoolBlock)complete;


/// 使用refresh_token刷新access_token
+ (void)refreshAccessTokenWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;



@end
