//
//  SLBasePageTitleView.h
//  EShop
//
//  Created by 王胜利 on 2018/2/24.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkChainHeader.h"


typedef void(^TitleBtnSelect)(NSInteger idx);

@interface SLBasePageTitleView : UIView


/// 标题数组
@property (strong, nonatomic) NSArray *titles;
/// 顶部按钮数组
@property (strong, nonatomic) NSMutableArray <UIView *>* btns;
/// 标题点击事件回调
@property (copy, nonatomic) TitleBtnSelect titleBtnSelect;
/// 当前选中的下标
@property (assign, nonatomic) NSUInteger currentIdx;


- (void)viewWithTitles:(NSArray *)titles titleBtnSelect:(TitleBtnSelect)selectBtnIdx;

/**
 滑动标题到对应的Idx
 
 @param idx 下标(从0开始)
 */
- (void)scrollToTitleWithIndex:(NSInteger)idx;


/**
 根据idx修改对应Title的Badge
 
 @param idx 下标(从0开始)
 */
- (void)changeBadge:(NSString *)badge idx:(NSInteger)idx;

@end
