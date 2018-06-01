//
//  EShopPhotoBrowser.h
//  EShopPhotoBrowser
//
//  Created by wsl on 2017/6/29.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageToolView.h"
@protocol bigPicSelectDelegate
@optional

-(void)bigPictureSelectFinishWithIsOringinal:(BOOL)isOrin;

-(void)bigPictureSelectArray:(NSMutableArray *)selectArray  WithIsOrin:(BOOL)isOrin;

@end
@interface BigPictureViewController : UIViewController
@property(nonatomic,weak)     id<bigPicSelectDelegate>  delegate;
///当前页
@property (nonatomic, assign) NSInteger                 page;
///图片Model数组
@property (nonatomic, strong) NSMutableArray            *photos;
///选中图片的数组
@property (nonatomic,strong)  NSMutableArray            *selectArray;
///工具栏
@property(nonatomic,strong)   ImageToolView             *imageToolView;
///是否原图
@property(nonatomic,assign)   BOOL                      isOringal;

@end
