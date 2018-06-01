//
//  TCSureMemoryView.h
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/26.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkChainHeader.h"

typedef void(^SureMemoryTapBlock)(NSString *word,NSUInteger index);


@interface TCSureMemoryView : UIView

/// 内容视图
@property (strong, nonatomic) UIScrollView *contentView;
/// 子标题
@property (strong, nonatomic) UILabel *subTitleLabel;
/// 警告文本
@property (strong, nonatomic) UILabel *tipLabel;
/// 确认助记词视图
@property (strong, nonatomic) UIView *selectedMemeoryWordView;
/// 助记词
@property (strong, nonatomic) UIView *noSelectMemoryWordView;
/// 下一步按钮
@property (strong, nonatomic) UIButton *nextButton;
/// 已经确认过的助记词
@property (strong, nonatomic) NSArray *selectedMemoryWords;
/// 未确认过的设置助记词
@property (strong, nonatomic) NSArray *noSelectMemoryWords;

@property (copy, nonatomic) SureMemoryTapBlock selectedMemoryWordTapAction;

@property (copy, nonatomic) SureMemoryTapBlock noSelectMemoryWordTapAction;

@end
