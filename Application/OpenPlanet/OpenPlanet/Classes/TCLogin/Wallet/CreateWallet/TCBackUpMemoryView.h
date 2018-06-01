//
//  TCBackUpMemoryView.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/16.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkChainHeader.h"
#import "TCWalletSubTipView.h"

@interface TCBackUpMemoryView : UIView

@property (strong, nonatomic) UIScrollView *contentView;
/// 子标题
@property (strong, nonatomic) UILabel *accountLabel;
/// 账号分割线
@property (strong, nonatomic) UIView *lineView;
/// 子标题
@property (strong, nonatomic) UILabel *subTitleLabel;
/// 警告文本
@property (strong, nonatomic) UILabel *tipLabel;
/// 助记词
@property (strong, nonatomic) UIView *memoryWordView;
/// 奖励
@property (strong, nonatomic) TCWalletSubTipView *subTipView;
// 设置助记词
@property (strong, nonatomic) NSArray *memoryWords;

/// 下一步按钮
@property (strong, nonatomic) UIButton *nextButton;


@end
