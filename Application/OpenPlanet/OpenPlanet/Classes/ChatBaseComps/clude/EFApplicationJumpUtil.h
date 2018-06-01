//
//  EFJumpApplicationObj.h
//  ESPChatComps
//
//  Created by 于仁汇 on 2017/8/9.
//  Copyright © 2017年 Pansoft. All rights reserved.

/*
 检测是否下载应用号资源文件与主数据的类
 */

#import <Foundation/Foundation.h>

typedef void(^JumpApplicationCompletionHandle)();
typedef void(^FailCompletionHandle)();

@interface EFApplicationJumpUtil : NSObject

/**
 检测下载应用号
 
 @param appID 应用号ID
 @param applicationName 应用号名称
 @param jumpApplication 成功下载资源文件与主数据之后的block
 */
- (void)checkApplicationLocalDateWithAppId:(NSInteger)appID applicationName:(NSString *)applicationName jumpApplicationBlock:(JumpApplicationCompletionHandle)jumpApplication fail:(FailCompletionHandle)failCompletionHandle;

@end
