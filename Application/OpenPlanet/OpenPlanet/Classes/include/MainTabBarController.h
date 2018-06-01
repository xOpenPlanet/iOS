//
//  MyTabBarController.h
//  YTAutoLayout
//
//  Created by fly on 14/12/16.
//  Copyright (c) 2014年 fly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarController : UITabBarController
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *panGestureRec;

@property (nonatomic, strong) UIView *leftView;
//显示左边菜单
- (void)showLeftView:(BOOL)animated;
- (void)closeSideBar:(BOOL)animated;
- (void)selectTabIndex:(NSInteger)index;
@end
 
