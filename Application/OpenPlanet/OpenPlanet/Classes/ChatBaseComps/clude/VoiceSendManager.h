//
//  VoiceSendManager.h
//  ESPChatComps
//
//  Created by YRH on 2018/3/29.
//  Copyright © 2018年 Pansoft. All rights reserved.
//
/*
 发送语音消息
 */

#import <Foundation/Foundation.h>
#import "JFMessageManager.h"

@interface VoiceSendManager : NSObject

+ (IMStructMessage *)voicePreSendMessageWithToUserID:(int)toUserID postType:(Byte)postType localPath:(NSString *)localPath time:(NSString *)time;

+ (void)voiceSendWithMessage:(IMStructMessage *)structMessage url:(NSString *)url;

@end
