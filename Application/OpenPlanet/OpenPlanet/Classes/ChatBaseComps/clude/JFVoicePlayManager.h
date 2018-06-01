//
//  JFVoicePlayManager.h
//  ESPChatComps
//
//  Created by YRH on 2018/3/31.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMStructMessage.h"

@protocol JFVoicePlayManagerDelegate <NSObject>
/// 将要开始下载语音
- (void)voiceWillBeginDownload;
/// 语音下载成功
- (void)voiceDownloadSuccessWithStructMessage:(IMStructMessage *)structMessage voiceData:(NSData *)voiceData filePath:(NSString *)fielPath;
/// 语音下载失败
- (void)voiceDownloadFailWithStructMessage:(IMStructMessage *)structMessage;
/// 开始播放语音
- (void)voiceStartPlay;
/// 停止播放语音
- (void)voiceStopPlay;
/// 播放器创建失败
- (void)voiceAudioPlayerCreateErrorWithError:(NSString *)error;
/// 播放器播放失败
- (void)voiceAudioPlayerPlayError;

@end

@interface JFVoicePlayManager : NSObject

@property (nonatomic, weak) id<JFVoicePlayManagerDelegate> delegate;

/**
 播放语音

 @param structMessage structMessage
 */
- (void)voicePlayManagerPlayVoiceWithStructMessage:(IMStructMessage *)structMessage;

/**
 停止播放
 */
- (void)voicePlayManagerStopPlayVoice;

@end
