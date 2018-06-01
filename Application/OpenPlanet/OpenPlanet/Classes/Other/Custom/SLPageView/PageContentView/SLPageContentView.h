//
//  SLPageContentView.h
//  TalkChain
//
//  Created by 王胜利 on 2018/4/8.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PageScrollBlock)(NSInteger idx,CGFloat progress);

@interface SLPageContentView : UIView

/// 初始化+方法
+ (instancetype)pageContentViewWithChildViews:(NSArray <UIView *>*)childViews;
/// 滑动之后的回调函数
@property (copy, nonatomic)PageScrollBlock pageScroll;
/// 设置当前页
- (void)setCurrentIndex:(NSInteger)index;

@end
