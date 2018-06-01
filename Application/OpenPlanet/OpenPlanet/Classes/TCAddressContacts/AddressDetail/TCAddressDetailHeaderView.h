//
//  TCAddressDetailHeaderView.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/15.
//  Copyright © 2018年 wsl. All rights reserved.
//  联系人详情头部View

#import <UIKit/UIKit.h>

@interface TCAddressDetailHeaderView : UIView
/// 返回按钮
@property (strong, nonatomic) UIButton * backButton;
/// 顶部背景图片
@property (strong, nonatomic) UIImageView *topBgImageView;
/// 头像
@property (strong, nonatomic) UIImageView *avatarImageView;
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;

@end
