//
//  BarItemSaveLocalDatas.h
//  ESPChatComps
//
//  Created by YRH on 2018/3/28.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

/*
 保存本地数据
 */
#import <UIKit/UIKit.h>

@class WriteLocalDetailsModle;

typedef NS_ENUM(NSUInteger, SaveLocalDatasType) {
    StaticImageType,
    GIFImageType,
    VoiceType,
    VideoType,
};

@interface WriteLocalDatasManager : NSObject

/**
 将数据写入到本地

 @param data 二进制数据
 @param type 类型
 @param fileName 文件名字(不写内部会自动填充上文件名)
 @return 返回带有 该文件本地路径，文件名，二进制数据的模型
 */
+ (WriteLocalDetailsModle *)writeDatasWithDatas:(NSData *)data fileType:(SaveLocalDatasType)type fileName:(NSString *)fileName;

@end

@interface WriteLocalDetailsModle : NSObject

/// 本地路径 (DocumentDirectory之后的路径)
@property (nonatomic, copy) NSString *localPath;
/// 文件名
@property (nonatomic, copy) NSString *fileName;
/// 二进制数据
@property (nonatomic, strong) NSData *data;
/// 时长
@property (nonatomic, strong) NSString *time;
/// 原图片
@property (nonatomic, strong) UIImage *originalImage;
/// 压缩后的图片
@property (nonatomic, strong) UIImage *compressionImage;

@end
