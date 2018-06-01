//
//  JFMessageNoticeView.h
//  ESPMobileView
//
//  Created by 王胜利 on 2018/4/9.
//  Copyright © 2018年 Pansoft. All rights reserved.
//  聊天页顶部公告栏组件

#import <UIKit/UIKit.h>


#pragma mark - 公告栏配置信息
@interface JFMessageNoticeViewConfig : NSObject
/// 标题
@property (copy, nonatomic) NSString *title;
/// 标题颜色
@property (strong, nonatomic) UIColor *titleColor;
/// 关闭图片
@property (strong, nonatomic) UIImage *closeImage;

@end


@class JFMessageNoticeView;

@protocol JFMessageNoticeViewDelegate <NSObject>

- (void)messageNoticeViewTouch:(JFMessageNoticeView *)view config:(JFMessageNoticeViewConfig *)config;

@end

@interface JFMessageNoticeView : UIView

@property (weak, nonatomic) id<JFMessageNoticeViewDelegate> delegate;
/// 显示聊天公告
- (void)showWithConfig:(JFMessageNoticeViewConfig *)config;
- (void)showWithTitle:(NSString *)title;

/// 隐藏
- (void)dismiss;
@end


