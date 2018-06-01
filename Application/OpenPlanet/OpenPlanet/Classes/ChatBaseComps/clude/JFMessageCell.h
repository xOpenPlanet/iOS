//
//  JFMessageCell.h
//  ChatComps
//
//  Created by Javor Feng on 2018/3/19.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IIMStruct.h"
#import "JFMessageItem.h"

@class JFMessageCell;

@protocol JFMessageCellDelegate <NSObject>

@optional
///内容长按事件代理
- (void)onMessageLongPressed:(JFMessageCell *)cell;
///内容点击事件代理
- (void)onMessageTaped:(JFMessageCell *)cell;
///头像长按事件代理
- (void)onAvatarLongPressed:(JFMessageCell *)cell;
///头像点击事件代理
- (void)onAvatarTaped:(JFMessageCell *)cell;
///辅助视图点击事件代理
- (void)onSignViewAvatarTaped:(JFMessageCell *)cell;

@end

@interface JFMessageCell : UITableViewCell

///消息
@property(nonatomic, weak) id<IIMStruct> messageStruct;

@property(nonatomic, weak) id<JFMessageCellDelegate> delegate;

///topView 一般用于显示时间戳
@property(nonatomic, strong) UIView                 *topView;
///topView左侧图标
@property(nonatomic, strong) UIImageView            *topImageView;
//topView中间label
@property(nonatomic, strong) UILabel                *topLabel;

///头像View
@property(nonatomic, strong) UIView                 *avatarView;
///头像图片
@property(nonatomic, strong) UIImageView            *avatarImageView;
///头像背景
@property(nonatomic, strong) UIImageView    *avatarBackgroundImageView;
///头像前景
@property(nonatomic, strong) UIImageView    *avatarForegroundImageView;

///titleView 一般用于显示用户名
@property(nonatomic, strong) UIView                 *titleView;

///是否显示等级
@property(nonatomic, assign) BOOL                   isGradeShow;
///gradeView等级view 
@property(nonatomic, strong) UIView                 *gradeView;
///gradeLabel等级Label
@property(nonatomic, strong) UILabel                *gradeLabel;
///signImageView标记View
@property(nonatomic, strong) UIImageView            *signImageView;
///名称Label
@property(nonatomic, strong) UILabel                *nameLabel;
///leftView
@property(nonatomic, strong) UIView                 *leftView;
///middleView  中间主内容区域
@property(nonatomic, strong) UIView                 *middleView;
///middleView背景
@property(nonatomic, strong) UIImageView    *middleViewBackgroundImageView;
///middleView中景
@property(nonatomic, strong) UIView                 *middleViewMidgroundView;
///middleView前景
@property(nonatomic, strong) UIImageView    *middleViewForegroundImageView;

///内容
@property(nonatomic, strong) id<JFMessageItem>      messageItem;

///rightView 一般用于显示发送进度条(延时1秒显示)/发送失败标志
@property(nonatomic, strong) UIView                 *rightView;
@property(nonatomic, strong) UIImageView            *rightSignImageView;

@property(nonatomic, strong) UILabel            *stateLabel;
@property(nonatomic, strong) UIImageView        *integralImageView;
@property(nonatomic, strong) UILabel            *integralLabel;


///BottomView 一般用于显示信息 如收到红包
@property(nonatomic, strong) UIView                 *bottomView;
///
@property(nonatomic, strong) UIImageView            *bottomLeftImageView;
///
@property(nonatomic, strong) UILabel                *bottomLabel;
///
@property(nonatomic, strong) UIImageView            *bottomRightImageView;

-(void)topViewHeight:(NSNumber *)height;
-(void)bottomViewHeight:(NSNumber *)height;
-(void)titleViewHeight:(NSNumber *)height;
-(void)middleViewHidden:(BOOL)hidden;

@end
