//
//  UIImage+CompressionImage.h
//  ESPChatComps
//
//  Created by YRH on 2018/3/28.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

/*
 压缩图片
 */

#import <UIKit/UIKit.h>

@interface UIImage (CompressionImage)

/**
 压缩图片

 @param currentImage 原图
 @return 压缩后图片的二进制数据
 */
+ (NSData *)compressionImageDataWithImage:(UIImage *)currentImage;

@end
