//
//  TCInviteCodeView.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/31.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCInviteCodeView : UIView

/// 背后可滑动View
@property (strong, nonatomic) UIView *bgScrollView;
/// 背景图
@property (strong, nonatomic) UIImageView *bgImageView;
/// 内容背景图
@property (strong, nonatomic) UIImageView *contentBgImageView;
/// 邀请码标题
@property (strong, nonatomic) UILabel *inviteCodeTitleLabel;
/// 邀请码
@property (strong, nonatomic) UILabel *inviteCodeLabel;
/// 拷贝邀请码
@property (strong, nonatomic) UIButton *inviteCodeCopyButton;
/// 奖励
@property (strong, nonatomic) UILabel *rewardLabel;
/// 二维码图片
@property (strong, nonatomic) UIImageView *qrImageView;
/// 二维码标题
@property (strong, nonatomic) UILabel *qrLabel;


@end
