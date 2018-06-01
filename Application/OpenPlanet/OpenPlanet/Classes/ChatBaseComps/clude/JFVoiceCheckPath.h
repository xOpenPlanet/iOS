//
//  JFVoiceCheckPath.h
//  ESPChatComps
//
//  Created by YRH on 2018/3/31.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

/*
 检查语音文件路径
 */

#import <Foundation/Foundation.h>
#import "IMStructMessage.h"

@class VoiceLocalDetails;
@interface JFVoiceCheckPath : NSObject

/**
 检测语音是否本地存储过，有返回本地路径，没有返回nil

 @param structMessage structMessage
 @return 语音文件的本地路径
 */
+ (VoiceLocalDetails *)checkLocalPathPlayVoiceWithStructMessage:(IMStructMessage *)structMessage;

@end

@interface VoiceLocalDetails : NSObject

/// 本地沙盒的完整路径
@property (nonatomic, copy) NSString *voiceLocalPath;
/// 二进制数据
@property (nonatomic, strong) NSData *voiceData;

@end
