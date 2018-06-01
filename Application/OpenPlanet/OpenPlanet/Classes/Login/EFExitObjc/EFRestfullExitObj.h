//
//  EFRestfullLExitObj.h
//  OSPMobile
//
//  Created by 于仁汇 on 2017/7/5.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

// restfull 退出

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JFMessageManager.h"

typedef void(^restfullExitSuccessCompletionHandle)(NSDictionary *responseDic);
typedef void(^restfullExitFailCompletionHandle)(NSString *error);

@interface EFRestfullExitObj : NSObject

/**
 restfull退出

 @param userId 用户ID
 @param passWord 用户密码
 @param token token
 @param deviceId deviceId
 @param success 成功的回调
 @param fail 失败的回调
 */
- (void)restfullExitWithUserId:(NSString *)userId passWord:(NSString *)passWord token:(NSString *)token deviceId:(NSString *)deviceId success:(restfullExitSuccessCompletionHandle)success fail:(restfullExitFailCompletionHandle)fail;

@end
