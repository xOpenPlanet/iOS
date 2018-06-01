//
//  SpreadsViewController.h
//  sq
//
//  Created by 于仁汇 on 16/12/1.
//  Copyright © 2016年 于仁汇. All rights reserved.
//

/*
 应用号 控制 侧滑与内容 的控制器类
 */

#import <UIKit/UIKit.h>

@protocol EFSpreadsViewControllerDelegate <NSObject>

- (void)presentedOneControllerPressedDissmiss;

@end

@interface EFSpreadsViewController : UIViewController

@property (nonatomic, weak) id<EFSpreadsViewControllerDelegate> delegate;

/// 侧滑出来的控制器
@property (nonatomic, strong) UIViewController *leftViewController;
/// 主控制器
@property (nonatomic, strong) UIViewController *mainViewController;

// 边缘滑动手势，加载本控制器上面
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer;
// 平移手势，在侧边栏显示的时候，添加在主界面上
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

/// 展示侧边界面
- (void)showLeftController:(BOOL)animated;
/// 隐藏侧边界面
- (void)showRootController:(BOOL)animated;


@end
