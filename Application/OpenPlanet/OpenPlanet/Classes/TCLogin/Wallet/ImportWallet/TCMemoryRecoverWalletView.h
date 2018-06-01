//
//  TCMemoryRecoverWalletView.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/28.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TCMemoryRecoverWalletView : UIScrollView

/// 警告文本
@property (strong, nonatomic) UILabel *tipLabel;
/// 助记词
@property (strong, nonatomic) UIView *memoryWordView;
/// 下一步按钮
@property (strong, nonatomic) UIButton *nextButton;

@end
