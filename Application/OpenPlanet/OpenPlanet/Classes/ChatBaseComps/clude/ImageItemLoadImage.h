//
//  ImageItemLoadImage.h
//  ESPChatComps
//
//  Created by 于仁汇 on 17/2/6.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IMStructMessage.h"
#import "ImageItemImageSize.h"

@interface ImageItemLoadImage : NSObject

/// 加载图片
- (void)loadImageWithMessage:(IMStructMessage *)message imageView:(UIImageView *)imageView;

@end
