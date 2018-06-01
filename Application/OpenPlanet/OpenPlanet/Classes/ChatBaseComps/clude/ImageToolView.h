//
//  ImageToolView.h
//  ESPChatComps
//
//  Created by 虎 谢 on 2018/3/27.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageToolView;

@protocol imageToolDelegate
@optional
///点击相册
-(void)imagetoolViewdidSelectPhotoAlbum:(ImageToolView *)imageToolView;
///点击发送
-(void)imagetoolViewdidSelectSendButton:(ImageToolView *)imageToolView;
///点击预览
-(void)imagetoolViewdidSelectPreButton:(ImageToolView *)imageToolView;
///点击编辑
-(void)imagetoolViewdidSelectEditButton:(ImageToolView *)imageToolView;
///点击原图
-(void)imagetoolViewdidSelectOringnalView:(ImageToolView *)imageToolView;
@end

@interface ImageToolView : UIView

@property(nonatomic,weak)  id<imageToolDelegate>  delegate;

///相册
@property(nonatomic,assign) BOOL            isPhotoButton;
@property(nonatomic,strong) UIButton        *photoAlbumButton;
///预览
@property(nonatomic,assign) BOOL            isPreScanButton;
@property(nonatomic,strong) UIButton        *preScanButton;
///编辑
@property(nonatomic,assign) BOOL            isEditButton;
@property(nonatomic,strong) UIButton        *editButton;
///闪照
@property(nonatomic,assign) BOOL            isFlashView;
@property(nonatomic,strong) UIView          *flashScanView;
///原图
@property(nonatomic,assign) BOOL            isOringnalView;
@property(nonatomic,strong) UIView          *oringinalView;
@property(nonatomic,strong) UILabel         *oringinalNameLabel;
@property(nonatomic,strong) UIImageView     *orinSelectView;
///发送
@property(nonatomic,strong) UIButton        *sendButton;

///初始化
-(instancetype)initWithPhotoButton:(BOOL)isPhotoButton
                     preScanButton:(BOOL)isPreScanButton
                        editButton:(BOOL)isEditButton
                         flashView:(BOOL)isFlashView
                      oringnalView:(BOOL)isOringnalView;

-(void)sendButtonStateSelectedWithTitle:(NSString *)title;
-(void)sendButtonStateUnselectedWithTitle:(NSString *)title;

-(void)otherButtonStateUnselectd:(UIButton *)button;
-(void)otherButtonStateSelectd:(UIButton *)button;

-(void)oringinalViewStateUnselectdWithTitle:(NSString *)title;
-(void)oringinalViewStateSelectdWithTitle:(NSString *)title;
@end
