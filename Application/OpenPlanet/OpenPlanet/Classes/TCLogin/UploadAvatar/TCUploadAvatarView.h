//
//  TCSetAvatarView.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/12.
//  Copyright © 2018年 wsl. All rights reserved.
//  设置头像View

#import <UIKit/UIKit.h>
#import "TalkChainHeader.h"
#import "TCWalletSubTipView.h"


@interface TCUploadAvatarView : UIView

/// 子标题图片
@property (strong, nonatomic) UIButton *avatarButton;
/// 昵称
@property (strong, nonatomic) UILabel *subTitleLabel;
/// 警告文本
@property (strong, nonatomic) UILabel *tipLabel;
/// 奖励
@property (strong, nonatomic) TCWalletSubTipView * subTipView;
/// 下一步按钮
@property (strong, nonatomic) UIButton *nextButton;


@end

