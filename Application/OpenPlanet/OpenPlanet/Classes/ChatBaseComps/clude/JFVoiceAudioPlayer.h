//
//  JFVoiceAudioPlayer.h
//  ESPChatComps
//
//  Created by YRH on 2018/3/31.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

/*
 音频播放器
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

/// 音频播放器创建失败
typedef void(^AudioPlayerCreateError)(NSString *localizedDescription);
/// 音频播放器播放完成
typedef void(^AudioPlayerDidFinishPlaying)(void);
/// 音频播放器播放失败
typedef void(^AudioPlayerPlayingError)(void);

@class JFVoiceAudioPlayerModel;

@interface JFVoiceAudioPlayer : NSObject

/// 音频播放器创建失败
@property (nonatomic, copy) AudioPlayerCreateError audioPlayerCreateError;
/// 音频播放器播放完成
@property (nonatomic, copy) AudioPlayerDidFinishPlaying audioPlayerDidFinishPlaying;
/// 音频播放器播放失败
@property (nonatomic, copy) AudioPlayerPlayingError audioPlayerPlayingError;

@property (nonatomic, strong, readonly) JFVoiceAudioPlayerModel *audioPlayerModel;

@property (nonatomic, strong, readonly) AVAudioPlayer *audioPlayer;

/**
 单例初始化

 @return JFVoiceAudioPlayer
 */
+ (instancetype)defaultVoiceAudioPlayer;

/**
 创建播放器

 @param data 语音二进制文件
 @param voiceLocalPath 语音本地路径
 */
- (void)playVoiceWithData:(NSData *)data voiceLocalPath:(NSString *)voiceLocalPath audioPlayerModel:(JFVoiceAudioPlayerModel *)audioPlayerModel;

/**
 播放
 */
- (void)play;

/**
 停止
 */
- (void)stop;

@end

@interface JFVoiceAudioPlayerModel : NSObject

@property (nonatomic, weak) id additional;

@end


