//
//  JFVoiceDownload.h
//  ESPChatComps
//
//  Created by YRH on 2018/3/31.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

/*
 语音下载
 */

#import <Foundation/Foundation.h>
#import "IMStructMessage.h"

@interface JFVoiceDownload : NSObject

/**
 下载语音

 @param structMessage structMessage
 @param success 成功，返回 语音二进制文件，本地路径，structMessage
 @param fail 失败，返回 structMessage
 */
+ (void)voiceDownloadWithStructMessage:(IMStructMessage *)structMessage downloadSuccess:(void(^)(NSData *voiceData, NSString *filePath, IMStructMessage *structMessage))success fail:(void(^)(IMStructMessage *structMessage))fail;

@end
