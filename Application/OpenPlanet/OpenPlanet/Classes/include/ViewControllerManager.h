//
//  ViewControllerManager.h
//  ESPMobile
//
//  Created by fly on 14/12/31.
//  Copyright (c) 2014年 Javor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"

@interface ViewControllerManager : UIViewController

/**
 *  控制器切换 push方法
 *
 *  @param controller 要显示的控制器
 *  @param animated   是否需要动画
 */
+(void)pushViewController:(UIViewController *)controller animated:(BOOL) animated;

/**
 *  控制器切换 push方法
 *
 *  @param controller 要显示的控制器
 *  @param animated   是否需要动画
 *  @param navigationBarHidden  是否隐藏navigationBar
 */
+(void)pushViewController:(UIViewController *)controller animated:(BOOL) animated navigationBarHidden:(BOOL)navigationBarHidden;

/**
 *  控制器切换
 *
 *  @param controller 要显示的控制器
 *  @param animated   是否需要动画
 *  @param completion 切换完成执行的代码
 */
+(void)presentViewController:(UIViewController *)controller animated:(BOOL) animated completion:(void (^)(void))completion;
/**
 *  控制器切换
 *
 *  @param controller 要显示的控制器
 *  @param animated   是否需要动画
 *  @param completion 切换完成执行的代码
 *  @param need       是否需要关闭按钮
 */
+(void)presentViewController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)(void))completion needDissmisButton:(BOOL) need;
/**
 *  关闭modal方式的控制器
 *
 *  @param flag       是否需要动画
 *  @param completion 关闭完成执行的代码
 */
+(void)closeViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;

/**
 *  在当前窗口显示view
 *
 *  @param view 要显示的view
 *  @param flag 是否需要遮盖
 */
+(void)showView:(UIView *)view isFullScreen:(BOOL) flag needsCloseButton:(BOOL) isNeedCloseBtn;

/**
 *  在当前窗口显示View  显示过程中不允许用户操作
 *
 *  @param view   要显示的View
 *  @param flag   是否需要遮盖
 *  @param second 显示的时间
 */
+(void)showView:(UIView *)view isFullScreen:(BOOL) flag needsCloseButton:(BOOL) isNeedCloseBtn  withSecond:(NSInteger) second;

+(void)popToRootViewControllerAnimated:(BOOL)animated;

/**
 *  隐藏正在显示的View
 */
+(void)hidenView;

/**
 *  获取当前控制器
 */
+(UIViewController *)currentViewController;

+(void)popViewControllerAnimated:(BOOL)animated;

+(MainTabBarController *)getMainTabbarController;
+(void)setMainTabbarController:(MainTabBarController *)tab;

@end
