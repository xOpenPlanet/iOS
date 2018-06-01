//
//  EFRestfulLoginOperation.h
//  OSPMobile
//
//  Created by 于仁汇 on 2017/9/19.
//  Copyright © 2017年 Pansoft. All rights reserved.
//  restful 登录类

#import <Foundation/Foundation.h>

// AF请求的block
typedef void(^LoginSuccessCompletionHandle)(NSDictionary *responseDic);
typedef void(^LoginFailCompletionHandle)(NSError *error);

// 请求成功block
typedef void(^RestfulSuccessCompletionHandle)(NSDictionary *responseDic);
// 请求失败block
typedef void(^RestfulFailCompletionHandle)(NSError *error);

@interface EFRestfulLoginOperation : NSObject

/**
 restful首次登录

 @param userName 用户名
 @param parametersDic 登录参数
 @param successCompletionHandle 成功
 @param failCompletionHandle 失败
 */
- (void)panRestfulLoginWithParametersDic:(NSDictionary *)parametersDic success:(RestfulSuccessCompletionHandle)successCompletionHandle fail:(RestfulFailCompletionHandle)failCompletionHandle;


/**
 restful登录

 @param success 成功
 @param fail 失败
 */
- (void)requestLoginServerSuccess:(LoginSuccessCompletionHandle)success fail:(LoginFailCompletionHandle)fail;
@end
