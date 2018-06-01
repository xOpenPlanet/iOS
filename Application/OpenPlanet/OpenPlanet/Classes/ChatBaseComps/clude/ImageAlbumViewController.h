//
//  ImageAlbumViewController.h
//  ESPChatComps
//
//  Created by 虎 谢 on 2018/3/27.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageToolView.h"

@protocol ImageAlbumDelegate
@optional
///取消选择的图片
-(void)imageChooseCancel;
///确定选择的图片
-(void)albumSelectArray:(NSMutableArray *)array WithIsisOringal:(BOOL)isOringal;
@end
@interface ImageAlbumViewController : UIViewController

@property(nonatomic,weak) id<ImageAlbumDelegate>    delegate;
///数据源
@property(nonatomic,strong) NSArray                 *dataSource;
///已选择的数据
@property(nonatomic,strong) NSMutableArray          *selectArray;
///工具栏
@property(nonatomic,strong) ImageToolView           *imageToolView;
///是否是原图
@property(nonatomic,assign) BOOL                    isOringal;

@end
