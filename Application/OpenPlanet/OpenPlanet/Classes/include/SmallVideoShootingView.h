//
//  SmallVideoShootingView.h
//  ESPChatComps
//
//  Created by 于仁汇 on 16/7/6.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmallVideoCaptureVideo.h"

@protocol SmallVideoShootingViewDegelate <NSObject>

/**
 *  点击fuzzyView的代理事件
 */
- (void)whenTouchFuzzyViewToDo;

/**
 *  按住圆形btn的代理事件
 */
- (void)whenTouchBtnToDo;

/**
 *  松开圆形btn的代理事件
 */
- (void)whenLooseBtnToDo:(NSString *)videoPath time:(NSString *)time localPath:(NSString *)localPath;

/**
 *  录制时间结束的代理事件
 */
- (void)videoTimeEndToDo:(NSString *)videoPath time:(NSString *)time localPath:(NSString *)localPath;

@end

@interface SmallVideoShootingView : UIViewController

/// 录像预览层
@property (nonatomic, strong) SmallVideoCaptureVideo *preView;
/// 进度条
@property (nonatomic, strong) UIView *lineView;
/// 录制视频的路径
@property (nonatomic, copy) NSString *videoPath;
/// 代理
@property (nonatomic, weak) id<SmallVideoShootingViewDegelate> delegate;

@end
