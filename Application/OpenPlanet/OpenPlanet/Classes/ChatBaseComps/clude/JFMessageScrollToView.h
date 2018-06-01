//
//  JFMessageScrollToView.h
//  TalkChain
//
//  Created by 王胜利 on 2018/4/16.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//  聊天页上面有多个未读消息(或者有@我消息)

#import <UIKit/UIKit.h>

typedef void(^VoidBlock)(void);

#pragma mark - JFMessageScrollToViewConfig配置
@interface JFMessageScrollToViewConfig: NSObject

/// 左边图片(优先级大于leftImageUrl)
@property (strong, nonatomic) UIImage *leftImage;
/// 左边图片Url(优先级小于leftImage)
@property (copy, nonatomic) NSString *leftImageUrl;
/// 标题
@property (copy, nonatomic) NSString *title;
/// 标题颜色
@property (strong, nonatomic) UIColor *titleColor;
/// 提示
@property (copy, nonatomic) NSString *tip;
/// 提示颜色
@property (strong, nonatomic) UIColor *tipColor;
/// 右边图片
@property (strong, nonatomic) UIImage *rightImage;

@end

@class JFMessageScrollToView;

@protocol JFMessageScrollToViewDelegate <NSObject>

- (void)messageScrollToViewTouch:(JFMessageScrollToView *)view config:(JFMessageScrollToViewConfig *)config;

@end

@interface JFMessageScrollToView : UIView

@property (weak, nonatomic) id<JFMessageScrollToViewDelegate> delegate;

/// 显示未读消息提示
- (void)showUnReadMessageWithConfig:(JFMessageScrollToViewConfig *)config;
- (void)showUnReadMessageWithLeftImage:(UIImage *)image title:(NSString *)title;
- (void)showUnReadMessageWithLeftImageUrl:(NSString *)imageUrl title:(NSString *)title;


/// 显示AtMe消息提示
- (void)showAtMeMessageWithConfig:(JFMessageScrollToViewConfig *)config;
- (void)showAtMeMessageWithLeftImageUrl:(NSString *)imageUrl title:(NSString *)title;

/// 隐藏
- (void)dismiss;

@end


