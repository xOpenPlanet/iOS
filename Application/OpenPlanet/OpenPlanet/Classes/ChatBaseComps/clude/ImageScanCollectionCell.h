//
//  ImageScanningCollectionCell.h
//  ESPChatComps
//
//  Created by 虎 谢 on 2018/3/26.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "ImageModel.h"

@class ImageScanCollectionCell;

@protocol imasgeScanDelegate
@optional
//选择当前图片
-(void)selectImageScanCollectionCell:(ImageScanCollectionCell *)cell;

@end

@interface ImageScanCollectionCell : UICollectionViewCell

@property(nonatomic,weak)   id<imasgeScanDelegate> delegate;
///展示图片的imageView
@property(nonatomic,strong) UIImageView *showImage;
///图片选择的imageView
@property(nonatomic,strong) UIImageView *selectSign;
///展示图片选择顺序的Label
@property(nonatomic,strong) UILabel     *selectLabel;
///选中的编号
@property(nonatomic,assign) NSInteger   selectedNumber;
///赋值的数据源
@property(nonatomic,strong) ImageModel  *model;

@end
