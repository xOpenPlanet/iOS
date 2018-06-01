//
//  PictureSendManager.h
//  ESPChatComps
//
//  Created by 虎 谢 on 2018/3/29.
//  Copyright © 2018年 Pansoft. All rights reserved.
//  发送图片管理器

#import <Foundation/Foundation.h>
#import "PansoftUpDwonload.h"
#import "JFMessageManager.h"
#import "IMStructMessage.h"
#import "EnvironmentVariable.h"
#import "Constant.h"

@interface PictureSendManager : NSObject

//上传下载管理类
@property(nonatomic,strong) PansoftUpDwonload       *psUpDownload;
@property(nonatomic,strong) JFMessageManager        *messageManager;
@property(nonatomic,assign) BOOL                    isOrin;
/// 发送图片方法(包含发送跟上传)
- (void)sendImageWithImage:(UIImage *)image isOrin:(BOOL)isOrin;
/// 分享发送图片
- (void)shareSendImageWithImage:(UIImage *)image toUserId:(NSString *)toUserId postType:(NSString *)postType;

@end
