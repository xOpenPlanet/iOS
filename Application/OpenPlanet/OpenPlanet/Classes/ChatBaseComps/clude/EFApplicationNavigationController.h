//
//  EFApplicationNavigationController.h
//  ESPChatComps
//
//  Created by 于仁汇 on 2017/8/14.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

/*
 应用号导航视图类
 */

#import <UIKit/UIKit.h>
#import "EFSpreadsViewController.h"

@protocol EFApplicationNavigationControllerDelegate <NSObject>

- (void)leftBarItemTouchAction:(UIBarButtonItem *)sender;

@end

@interface EFApplicationNavigationController : UINavigationController

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, strong) EFSpreadsViewController *spreadsVC;
@property (nonatomic, weak) id<EFApplicationNavigationControllerDelegate> barDelegate;

@end
