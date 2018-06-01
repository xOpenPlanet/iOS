//
//  ImageItemImageSize.h
//  ESPChatComps
//
//  Created by 于仁汇 on 17/2/6.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IMStructMessage.h"

@interface ImageItemImageSize : NSObject

/// 消息体是json格式的，计算图片尺寸
- (CGSize)sizeWithEntitysMessageIsJsonWithScale:(NSString *)scale IMStructMessage:(IMStructMessage *)message;

/// 消息体非json格式的，计算图片尺寸
- (CGSize)sizeWithEntitysWithScale:(NSString *)scale IMStructMessage:(IMStructMessage *)message imageView:(UIImageView *)imageView image:(UIImage *)entity;

@end
