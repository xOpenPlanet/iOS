//
//  MessageDbManager+AdditionalActions.h
//  ESPChatComps
//
//  Created by 于仁汇 on 2017/8/24.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

/*
 数据库分类
 */

#import "MessageDbManager.h"

@interface MessageDbManager (AdditionalActions)

/**
 根据消息ID 来查找某条消息

 @param messageID 消息ID
 @return 查找到就返回该条消息，查找不到就返回空
 */
- (IMStructMessage *)selectMessageWithMessageId:(NSString *)messageID;

/**
 更新消息内容

 @param messageID 消息ID
 @param message 消息内容
 */
- (void)updateMessageWithMessageId:(NSString *)messageID messageStr:(NSString *)message;

@end
