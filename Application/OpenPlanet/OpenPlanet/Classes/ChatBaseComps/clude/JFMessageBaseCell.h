//
//  JFMessageBaseCell.h
//  ESPChatComps
//
//  Created by Javor on 16/4/12.
//  Copyright (c) 2016年 Pansoft. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "IIMStruct.h"
#import "JFMessageItem.h"

@class JFMessageBaseCell;

@protocol JFMessageBseCellDelegate <NSObject>

///内容长按事件代理
- (void)onMessageLongPressed:(JFMessageBaseCell *)cell;
///内容点击事件代理
- (void)onMessageTaped:(JFMessageBaseCell *)cell;
///头像长按事件代理
- (void)onAvatarLongPressed:(JFMessageBaseCell *)cell;
///头像点击事件代理
- (void)onAvatarTaped:(JFMessageBaseCell *)cell;
///辅助视图点击事件代理
- (void)onSignViewAvatarTaped:(JFMessageBaseCell *)cell;

@end

typedef enum {
    /// 方形
    HeaderImageViewShapeSquare = (Byte)0,
    /// 圆形
    HeaderImageViewShapeCircle = (Byte)1
}headerImageViewShape;


@interface JFMessageBaseCell : UITableViewCell

///消息
@property(nonatomic, weak) id<IIMStruct> messageStruct;
///BseCell代理
@property(nonatomic, weak) id<JFMessageBseCellDelegate> delegate;
///头像
@property(nonatomic, strong) UIImageView            *avatarImageView;
///认证 V
@property(nonatomic, strong) UIImageView            *vImageView;
///用户名Label
@property(nonatomic, strong) UILabel                *userNameLabel;
///头像与气泡间的三角
@property(nonatomic, strong) UIImageView            *angleUImageView;
///气泡背景
@property(nonatomic, strong) UIView                 *bubbleView;
///内容
@property(nonatomic, strong) id<JFMessageItem>      messageItem;
///TopView 一般用于显示时间戳
@property(nonatomic, strong) UIView                 *topView;
///默认TopView里面为Label
@property(nonatomic, strong) UILabel                *topLabel;
///TopView 一般用于显示具体内容
@property(nonatomic, strong) UIImageView            *middleView;
///BottomView 一般用于显示信息 如收到红包
@property(nonatomic, strong) UIView                 *bottomView;
///默认BottomView里面为Label
@property(nonatomic, strong) UILabel                *bottomLabel;
///标志区域 用于显示发送进度条(延时1秒显示)/发送失败标志
@property(nonatomic, strong) UIView                 *SignView;
///个人ID
@property(nonatomic, copy)  NSString                *chatID;
/// 是否显示时间
@property (nonatomic, copy) NSString                *showTime;
/// 头像形状
@property (nonatomic, assign) Byte                  headerImageViewShape;
///cell信息
@property (nonatomic,strong)  NSMutableDictionary   *cellInfoDic;
///失败消息发送的等待菊花
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
///返回高度
-(CGFloat)heightWithEntity;
-(CGFloat)heightWithMessage:(IMStructMessage *)message;
@end
