//
//  TCWalletSubTipView.h
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/23.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImageView.h"

@interface TCWalletSubTipView : UIView
/// 奖励
@property (strong, nonatomic) UILabel * tipLabel;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *rewardLabel;
@property (strong, nonatomic) FLAnimatedImageView *rewardImageView;


@end
