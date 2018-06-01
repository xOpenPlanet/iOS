//
//  EFVoicePlayerManager.h
//  ESPChatComps
//
//  Created by zgb on 16/7/6.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "IMStructMessage.h"

@protocol VoicePlayAnimationDelegate <NSObject>

- (void)voiceStart;
- (void)voiceEnd;

@end

@interface EFVoicePlayerManager : NSObject<AVAudioPlayerDelegate>

@property (nonatomic, strong  ) AVAudioPlayer              *audioPlayer;
@property (nonatomic, weak    ) id<VoicePlayAnimationDelegate> delegate;
@property (nonatomic, readonly) NSData                     *lastData;
@property (nonatomic, strong) IMStructMessage *lastMessage;

+ (instancetype)shareInstance;

- (void)playVoiceWithData:(NSData *)data message:(IMStructMessage *)message;
- (void)play;
- (void)stop;

@end
