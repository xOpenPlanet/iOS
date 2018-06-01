//
//  TCUploadFansView.h
//  OpenPlanet
//
//  Created by 王胜利 on 2018/5/2.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCWalletSubTipView.h"

@interface TCUploadFansView : UIView
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
