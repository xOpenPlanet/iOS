//
//  JFVoiceItemLength.h
//  ESPChatComps
//
//  Created by YRH on 2018/3/30.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

/*
 获取 voiceItem 的长度
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JFVoiceItemLength : NSObject

/**
 获取语音时长

 @param timeDuration timeDuration
 @return 语音时长字符串
 */
+ (NSString *)voiceTime:(CGFloat)timeDuration;

/**
 item的size

 @param timeDuration timeDuration
 @return item的
 */
+ (CGSize)voiceViewLengthWithVoiceTime:(CGFloat)timeDuration;

@end
