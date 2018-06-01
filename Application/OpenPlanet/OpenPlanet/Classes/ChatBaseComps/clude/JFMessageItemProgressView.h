//
//  ProgressView.h
//  KeyBoardTest
//
//  Created by YRH on 2018/4/3.
//  Copyright © 2018年 YRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AnimationFinish)(void);

@interface JFMessageItemProgressView : UIView

/**
 背景色
 */
@property (nonatomic, strong) UIColor *maskBackgroundColor;

/**
 圆圈颜色
 */
@property (nonatomic, strong) UIColor *circleColor;

/**
 字体颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 圆圈宽度
 */
@property (nonatomic, assign) CGFloat circleLineWidth;

/**
 改变百分比进度

 @param percent 进度
 @param animationFinish 动画完成之后的回调
 */
- (void)changePercent:(CGFloat)percent animationFinish:(AnimationFinish)animationFinish;

@end
