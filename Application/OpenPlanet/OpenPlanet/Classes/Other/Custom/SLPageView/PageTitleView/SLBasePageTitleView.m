//
//  SLBasePageTitleView.m
//  EShop
//
//  Created by 王胜利 on 2018/2/24.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "SLBasePageTitleView.h"


@implementation SLBasePageTitleView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        self.currentIdx = 0;
        self.titles = [NSArray array];
        self.btns = [NSMutableArray array];
    }
    return self;
}


#pragma mark 类构造方法格式化标题
- (void)viewWithTitles:(NSArray *)titles titleBtnSelect:(TitleBtnSelect)selectBtnIdx{
    /// 设置btn按钮点击事件回调函数
    if (self.titleBtnSelect != selectBtnIdx) {
        self.titleBtnSelect = selectBtnIdx;
    }
    self.titles = titles;
}

#pragma mark - 修改badge未读消息数
- (void)changeBadge:(NSString *)badge idx:(NSInteger)idx{
    Log(@"子类覆盖实现此方法，实现修改badge数目提醒");
}


#pragma mark 根据Idx设置顶部按钮的背景颜色和位置
- (void)scrollToTitleWithIndex:(NSInteger)idx{
    /// 如果下标相同，即不需要切换分页的时候直接返回
    if (self.currentIdx == idx) {
        return;
    }
    self.currentIdx = idx;
}



@end

