//
//  CWTalkBackView.h
//  QQVoiceDemo
//
//  Created by 亦晴 on 2017/10/4.
//  Copyright © 2017年 亦晴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWRecordModel.h"

@protocol CWTalkBackViewDelegate<NSObject>
- (void) sendRecordActionWithRecordModel:(CWRecordModel *)model; // 发送语音
- (void) recordTimeShortAction; // 录音时间太短
@end
//----------------------对讲界面---------------------------------//
@interface CWTalkBackView : UIView
@property (nonatomic, copy) NSString * userId; //userId作为主文件夹(2369/CWVoice/2131343344.wav)
@property (nonatomic, weak) id<CWTalkBackViewDelegate> delegate;
@end
