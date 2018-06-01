//
//  SmallVideoCaptureVideo.h
//  ESPChatComps
//
//  Created by 于仁汇 on 16/7/7.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^Block)(NSString *);

@interface SmallVideoCaptureVideo : UIView
/**
 *  录制视频
 */
@property (nonatomic, copy) NSString *smallVideoPath;

@property (nonatomic, copy) NSString *smallVideoLocalPath;

@property (nonatomic, copy) Block block;

/**
 *  停止录制
 */
- (void)stopCapture;
/**
 *  开始录制
 */
- (void)startCapture;
/**
 *  压缩文件
 */
- (void)compressVideo;

@end
