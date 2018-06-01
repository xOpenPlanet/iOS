//
//  EFExitObj.h
//  OSPMobile
//
//  Created by 于仁汇 on 2017/7/6.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^exitSuccessCompletionHandle)(NSDictionary *responseDic);
typedef void(^exitFailCompletionHandle)(NSString *error);

@interface EFExitObj : NSObject

/**
 退出当前用户（退出登录,此方法中包含JFMessageManager的代理）

 @param success 成功的回调
 @param fail 失败的回调
 */
- (void)exitObjSuccess:(exitSuccessCompletionHandle)success fail:(exitFailCompletionHandle)fail;

/**
 删除基本参数并退出(不包含JFMessageManager代理,onMessageManagerDidDisConnect代理走完之后执行)
 
 @param success 成功的回调
 @param fail 失败的回调
 */
- (void)exitOperationAndRemoveSomeParameterSuccess:(exitSuccessCompletionHandle)success fail:(exitFailCompletionHandle)fail;

@end
