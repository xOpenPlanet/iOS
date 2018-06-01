//
//  JFMessageScrollDownView.h
//  ESPMobileView
//
//  Created by 王胜利 on 2018/4/10.
//  Copyright © 2018年 Pansoft. All rights reserved.
//  聊天页下面收到新消息（雨滴形状组件）

#import <UIKit/UIKit.h>


@class JFMessageScrollDownView;
@protocol JFMessageScrollDownViewDelegate <NSObject>
- (void)messageScrollDownViewTouch:(JFMessageScrollDownView *)view;
@end


@interface JFMessageScrollDownView : UIView

@property (weak, nonatomic) id<JFMessageScrollDownViewDelegate> delegate;

/// 显示新消息提示
- (void)showWithCount:(NSString *)count;
/// 隐藏
- (void)dismiss;

@end
