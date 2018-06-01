//
//  ImageModel.h
//  ESPChatComps
//
//  Created by 虎 谢 on 2018/3/27.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "TZAssetModel.h"

@interface ImageModel : NSObject
///图片PHAsset格式
@property(nonatomic,strong) PHAsset         *asset;
///选择的编号
@property(nonatomic,assign) NSInteger       selectNum;
///展示图片(缩略图)
@property(nonatomic,strong) UIImage         *showImage;
///图片数据data
@property(nonatomic,strong) NSData          *imageData;
///图片宽度
@property(nonatomic,assign) NSInteger       imageWidth;
///图片高度
@property(nonatomic,assign) NSInteger       imageHeight;
///图片内存大小
@property(nonatomic,assign) NSInteger       imageMemory;
///图片原图
@property(nonatomic,strong) UIImage         *orinImage;

@end
