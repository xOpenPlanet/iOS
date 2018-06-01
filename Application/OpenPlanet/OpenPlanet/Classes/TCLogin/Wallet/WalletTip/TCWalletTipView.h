//
//  TCWalletTipView.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/12.
//  Copyright © 2018年 wsl. All rights reserved.
//  导入钱包View

#import <UIKit/UIKit.h>
#import "TCWalletSubTipView.h"

@interface TCWalletTipView : UIView

/// 子标题图片
@property (strong, nonatomic) UIImageView *subTitleImageView;
/// 子标题
@property (strong, nonatomic) UILabel *subTitleLabel;
/// 警告文本
@property (strong, nonatomic) UILabel *tipLabel;
/// 奖励
@property (strong, nonatomic) TCWalletSubTipView * subTipView;
/// 下一步按钮
@property (strong, nonatomic) UIButton *nextButton;
/// 导入按钮
@property (strong, nonatomic) UIButton *importWalletButton;

@end
