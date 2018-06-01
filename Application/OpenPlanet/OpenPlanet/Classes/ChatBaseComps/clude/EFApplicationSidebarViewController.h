//
//  EFLeftViewController.h
//  ESPChatComps
//
//  Created by 于仁汇 on 16/9/20.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

/*
 应用号侧滑界面
 */

#import <UIKit/UIKit.h>
#import "StubObject.h"
#import "EFLeftOperationView.h"

@protocol UpdateDelegate <NSObject>

@optional

-(void)updateActionWithDate:(NSMutableArray *)dataArray;

@end

@protocol EFLeftViewControllerDelegate <NSObject>

/// 返回代理
- (void)backViewControllerDelegateEvent:(UIButton *)sender;

@end

@interface EFApplicationSidebarViewController : UIViewController
@property (nonatomic, strong) EFLeftOperationView *soundView; // 铃声
@property (nonatomic, strong) EFLeftOperationView *shakeView; // 震动
@property (nonatomic, strong) EFLeftOperationView *botherView;// 免打扰
@property (nonatomic, strong) EFLeftOperationView *updateView;// 升级
/// 左侧tableview的数据
@property (nonatomic, strong) NSMutableArray *tableArray;
/// 顶部基本信息数据
@property (nonatomic, strong) StubObject *headerApplicationInfo;
/// 图片路径
@property (nonatomic, copy) NSString *imagePath;
/// 公众号ID
@property (nonatomic, assign) NSInteger applicetionId;

/// 字体颜色
@property (nonatomic, strong) UIColor *viewTextColor;

/// 上一个leftview
@property (nonatomic, strong) UIView *upView;

@property (nonatomic,weak) id <UpdateDelegate> delegate;
@property (nonatomic, weak) id<EFLeftViewControllerDelegate> leftDelegate;

- (instancetype)initWithApplicationId:(NSInteger)applicationId;

@end
