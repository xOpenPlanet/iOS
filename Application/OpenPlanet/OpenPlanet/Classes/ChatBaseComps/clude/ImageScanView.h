//
//  ImageScanning.h
//  ESPChatComps
//
//  Created by 虎 谢 on 2018/3/26.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScanCollectionCell.h"
#import "ImageToolView.h"
#import "ImageAlbumViewController.h"
#import "BigPictureViewController.h"

@protocol ImageScanViewDelegate

@optional

-(void)selectArray:(NSMutableArray *)array WithIsisOringal:(BOOL)isOringal;

@end

@interface ImageScanView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,imasgeScanDelegate,imageToolDelegate,ImageAlbumDelegate,bigPicSelectDelegate>
///数据源
@property(nonatomic,strong) NSMutableArray               *dataSource;
///选中的数据源
@property(nonatomic,strong) NSMutableArray               *selectArray;
///展示图片view
@property(nonatomic,strong) UICollectionViewFlowLayout   *flowLayout;
@property(nonatomic,strong) UICollectionView             *collectionView;
///下边工具栏
@property(nonatomic,strong) ImageToolView                *imageToolView;
///是否是原图
@property(nonatomic,assign) BOOL                         isOringal;
@property(nonatomic,weak)   id<ImageScanViewDelegate>    delegate;
///权限提醒
@property(nonatomic,strong) UIView                       *tipView;
@property(nonatomic,strong) UILabel                      *tipLabel;
@property(nonatomic,strong) UIButton                     *settingButton;
-(void)reloadImageData;
@end
