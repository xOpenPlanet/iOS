//
//  SLTitleView.m
//  EShop
//
//  Created by 王胜利 on 2018/2/24.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "SLTitleView.h"
#import "SLBadgeButton.h"
#import "SLBaseScrollView.h"

@interface SLTitleView()

/// 滑动标题栏
@property (strong, nonatomic) SLBaseScrollView *titleScrollView;
/// 滑动的线
@property (strong, nonatomic) UIView *scrollLine;
/// 标题类型
@property (assign, nonatomic) SLPageViewTitleType titleType;


/// 标题默认颜色
@property (strong, nonatomic) UIColor *titleNormalColor;
/// 标题选中颜色
@property (strong, nonatomic) UIColor *titleSelectColor;
/// 线的颜色
@property (strong, nonatomic) UIColor *lineColor;
/// 标题字体大小
@property (assign, nonatomic) CGFloat titleFontSize;

@end


@implementation SLTitleView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.titleNormalColor =cDarkGrayColor;
        self.titleSelectColor =cBlackColor;
        self.lineColor = cRedColor;
        self.titleFontSize = 15.0;
        self.titleType = SLPageViewTitleTypeNone;
        self.theme_backgroundColor =  [UIColor theme_colorPickerForKey:@"topLine" fromDictName:@"wallet"];
        self.titleScrollView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud" fromDictName:@"wallet"];
    }
    return self;
}

#pragma mark - 更新布局
- (void)layoutSubviews{
    /// 布局滑动的线
    [self layoutScrollLine];
    [super layoutSubviews];
}

#pragma mark - 配置标题栏样式
+ (instancetype)viewWithTitles:(NSArray *)titles titleBtnSelect:(TitleBtnSelect)selectBtnIdx TitleNormalColor:(UIColor *)titleNormalColor titleSelectColor:(UIColor *)titleSelectColor lineColor:(UIColor *)lineColor titleType:(SLPageViewTitleType)titleType{
    SLTitleView *view = [[SLTitleView alloc]init];
    [view viewWithTitles:titles titleBtnSelect:selectBtnIdx];
    view.titleNormalColor = titleNormalColor;
    view.titleSelectColor = titleSelectColor;
    view.lineColor = lineColor;
    view.titleType = titleType;
    view.scrollLine.backgroundColor =lineColor;
    [view setTitlesAndThemeColor];
    view.titleScrollView.scrollEnabled = (titleType == SLPageViewTitleTypeTitleWidthAutomatic);

    return view;
}


- (void)buttonAction:(UIButton *)sender{
    self.titleBtnSelect(sender.tag - 100);
}


#pragma mark 初始化标题和主题色
- (void)setTitlesAndThemeColor{
    /// 均分样式需要设置宽度
    if (self.titleType == SLPageViewTitleTypeNone) {
        self.titleScrollView.contentSize  = CGSizeMake(self.titleScrollView.bounds.size.width, 0);
    }
    /// 设置标题
    for (int i = 0 ; i < self.titles.count; i++) {
        UIView *lastView;
        if (self.btns.count > 0) {
            lastView = self.btns.lastObject;
        }

        NSString *title = self.titles[i];
        SLBadgeButton *btn = [SLBadgeButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i+100;
        UIColor *titleColor = i==0?self.titleSelectColor:self.titleNormalColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        btn.titleLabel.font = FONT(self.titleFontSize);
        [btn setTitle:SafeString(title) forState:UIControlStateNormal];
        [self.titleScrollView addSubview:btn];
        [self.btns addObject:btn];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

        /// 标题宽
        CGFloat titleWidth = [SafeString(title) boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(self.titleFontSize)} context:nil].size.width;

        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.centerY.equalTo(self.titleScrollView);
            if (self.titleType == SLPageViewTitleTypeNone) {
                make.width.equalTo(self.titleScrollView).multipliedBy(1.0/self.titles.count);
            }else{
                make.width.mas_equalTo(titleWidth+20);
            }
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            }else{
                make.left.equalTo(self.titleScrollView);
            }
            /// 最后一个添加距右的约束
            if (i == self.titles.count-1){
                make.right.equalTo(self.titleScrollView);
            }
        }];
    }
}

#pragma mark - 修改badge未读消息数
- (void)changeBadge:(NSString *)badge idx:(NSInteger)idx{
    SLBadgeButton *btn = (SLBadgeButton *)self.btns[idx];
    btn.badge = badge;
}


#pragma mark 根据Idx设置顶部按钮的背景颜色和位置
- (void)scrollToTitleWithIndex:(NSInteger)idx{
    [super scrollToTitleWithIndex:idx];
    [self layoutScrollLine];
    WEAK(self)
    [UIView animateWithDuration:0.2 animations:^{
        /// 2.设置选中按钮的颜色改变
        for (UIButton *btn in weakself.btns) {
            UIColor *color = (btn.tag == idx+100)?weakself.titleSelectColor:weakself.titleNormalColor;
            [btn setTitleColor:color forState:UIControlStateNormal];
        }

        /// 3.自动滑动TitleScroll
        if (weakself.titleScrollView.contentSize.width > weakself.titleScrollView.bounds.size.width) {
            UIView *view = self.btns[idx];
            CGFloat btnCenterX = view.center.x;
            CGFloat headerScrollWidth = weakself.titleScrollView.bounds.size.width;
            if (btnCenterX > headerScrollWidth/2 && (weakself.titleScrollView.contentSize.width - btnCenterX) > headerScrollWidth/2) {
                weakself.titleScrollView.contentOffset = CGPointMake(btnCenterX - headerScrollWidth/2, 0);
            }else if (btnCenterX < headerScrollWidth/2){
                weakself.titleScrollView.contentOffset = CGPointMake(0, 0);
            }else if ((weakself.titleScrollView.contentSize.width - btnCenterX) < headerScrollWidth/2){
                weakself.titleScrollView.contentOffset = CGPointMake(weakself.titleScrollView.contentSize.width-headerScrollWidth, 0);
            }
        }

        [weakself layoutIfNeeded];
    }];
}

#pragma mark - 布局滑动的线
- (void)layoutScrollLine{
    [self.titleScrollView layoutIfNeeded];
    /// 标题宽
    CGFloat titleBtnX = [self.btns[self.currentIdx] frame].origin.x;
    CGFloat btnWidth = self.btns[self.currentIdx].bounds.size.width;
    CGFloat titleWidth = [self.titles[self.currentIdx] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(self.titleFontSize)} context:nil].size.width;
    CGFloat lineXOffset = titleBtnX +(btnWidth - titleWidth)/2;
    [self.scrollLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth);
        make.left.equalTo(self.titleScrollView).offset(lineXOffset);
    }];
}

#pragma mark - lazyload
- (SLBaseScrollView *)titleScrollView{
    if (!_titleScrollView) {
        _titleScrollView = [SLBaseScrollView new];
        _titleScrollView.backgroundColor = cWhiteColor;
        _titleScrollView.showsVerticalScrollIndicator = NO;
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.bounces = NO;
        [self addSubview:_titleScrollView];
        [_titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(@40);
            make.bottom.equalTo(self).offset(-5);
        }];
    }
    return _titleScrollView;
}
- (UIView *)scrollLine{
    if (!_scrollLine) {
        _scrollLine = [UIView new];
        [self.titleScrollView addSubview:_scrollLine];
        [_scrollLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@1.5);
            make.width.mas_equalTo(@0);
            make.bottom.equalTo(self.titleScrollView);
        }];
    }
    return _scrollLine;
}

@end

@implementation SLPageEntity



@end
