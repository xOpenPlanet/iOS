//
//  EFApplicationViewController.h
//  ESPChatComps
//
//  Created by 于仁汇 on 2017/7/30.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

/*
 应用号标签导航类
 */

#import <UIKit/UIKit.h>
#import "EFApplicationSidebarViewController.h"
#import "EFChatLeftViewController.h"
#import "StubObject.h"

@interface EFApplicationTabBarController : UITabBarController

/// 左侧控制器
//@property (nonatomic, strong) EFChatLeftViewController *leftViewController;


//@property(nonatomic, strong) EFLeftViewController *leftVC;


- (instancetype)initWithDataArray:(NSArray *)dataArray WithHtmlpath:(NSString *)htmlpath WithIsFromList:(BOOL)isFromList userID:(NSInteger)userID;

/// 更新UI界面
- (void)updateApplictionContentDataArray:(NSArray *)dataArray;
//- (void)pushEfTabbarById:(NSString *)idStr;

@end
