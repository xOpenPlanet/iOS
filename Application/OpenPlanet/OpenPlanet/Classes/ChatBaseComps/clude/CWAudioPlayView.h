//
//  CWAudioPlayView.h
//  QQVoiceDemo
//
//  Created by 亦晴 on 2017/10/4.
//  Copyright © 2017年 亦晴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWRecordModel.h"

@protocol CWAudioPlayViewDelegate<NSObject>
- (void) sendRecordActionVoiceModel:(CWRecordModel *)model;
@end
@interface CWAudioPlayView : UIView

@property (nonatomic,assign) CGFloat progressValue;
@property (nonatomic, weak)id<CWAudioPlayViewDelegate> delegate;
@end
