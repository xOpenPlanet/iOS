//
//  TCLoginBaseView.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/10.
//  Copyright © 2018年 wsl. All rights reserved.
//  登录页面基类

#import <UIKit/UIKit.h>
#import "TalkChainHeader.h"

@interface TCLoginBaseView : UIView

/// 返回按钮
@property (strong, nonatomic) UIButton * backButton;
/// 顶部背景图片
@property (strong, nonatomic) UIImageView *topBgImageView;
/// 内容View
@property (strong, nonatomic) UIView *contentView;
/// 头像
@property (strong, nonatomic) UIImageView *tipImageView;
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
/// 介绍
@property (strong, nonatomic) UILabel *tipLabel;
/// 内容变化区域
@property (strong, nonatomic) UIView *customView;
/// 下一步按钮
@property (strong, nonatomic) UIButton *nextButton;

@end
