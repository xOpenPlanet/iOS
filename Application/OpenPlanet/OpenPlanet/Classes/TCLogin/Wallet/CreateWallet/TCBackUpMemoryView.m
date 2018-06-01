//
//  TCBackUpMemoryView.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/16.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "TCBackUpMemoryView.h"

@implementation TCBackUpMemoryView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.lineView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"topLine" fromDictName:@"wallet"];
        self.subTitleLabel.theme_textColor  = [UIColor theme_colorPickerForKey:@"titleColor" fromDictName:@"wallet"];
        self.tipLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"tipColor" fromDictName:@"login"];
        self.nextButton.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"nextButtonBgColor" fromDictName:@"login"];
        self.nextButton.theme_tintColor = [UIColor theme_colorPickerForKey:@"nextButtonTintColor" fromDictName:@"login"];
    }
    return self;
}

- (void)setMemoryWords:(NSArray *)memoryWords{
    _memoryWords = memoryWords;

    /// 列数
    NSInteger columnNum = 2;
    /// 行数(向上取整)
    NSInteger lineNum = ceilf((CGFloat)memoryWords.count/columnNum);
    /// item高度
    CGFloat itemHeight = 40;
    /// 间隔
    CGFloat space = 10;
    /// item宽
    CGFloat itemWidth = (SCREEN_WIDTH - 20 - space*(columnNum + 1)) / columnNum;


    for (int i = 0; i < memoryWords.count; i ++) {

        /// 第几列
        NSInteger columnIdx = i % columnNum;
        /// 第几行
        NSInteger lineIdx = floor((CGFloat)i / columnNum);


        UIView *lastView;
        if (self.memoryWordView.subviews.count > 0) {
            lastView = self.memoryWordView.subviews.lastObject;
        }


        NSString *word = memoryWords[i];
        UILabel *label = [UILabel new];
        label.text = [NSString stringWithFormat:@"  %d.%@",i+1,word];
        label.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"tipColor" fromDictName:@"login"];
        label.textColor = cWhiteColor;
        label.font = BOLD_FONT(17);
        [self.memoryWordView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(itemWidth));
            make.height.equalTo(@(itemHeight));
            make.top.equalTo(self.memoryWordView).offset(lineIdx * itemHeight + (lineIdx+1)*space);
            make.left.equalTo(self.memoryWordView).offset(columnIdx * itemWidth + (columnIdx+1)*space);

            if(columnIdx == columnNum-1){
                make.right.equalTo(self.memoryWordView).offset(-space);
            }

            if(lineIdx == lineNum-1){
                make.bottom.equalTo(self.memoryWordView).offset(-space);
            }
        }];
    }

}

#pragma mark - lazyload
- (UIScrollView *)contentView{
    if (!_contentView) {
        _contentView  = [UIScrollView new];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _contentView;
}

- (UILabel *)accountLabel{
    if (!_accountLabel) {
        _accountLabel = [UILabel new];
        _accountLabel.numberOfLines = 0;
        _accountLabel.font = BOLD_FONT(17);
        _accountLabel.textColor = TCThemeColor;
        _accountLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_accountLabel];
        [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.right.equalTo(self.contentView).inset(20);
        }];
    }
    return _accountLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.accountLabel.mas_bottom).offset(10);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@10);
        }];
    }
    return _lineView;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.font = BOLD_FONT(17);
        _subTitleLabel.textColor = cTextColor;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_subTitleLabel];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(5);
            make.left.right.equalTo(self.contentView).inset(20);
        }];
    }
    return _subTitleLabel;
}


- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = FONT(13);
        _tipLabel.numberOfLines = 0;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subTitleLabel.mas_bottom).offset(10);
            make.left.right.equalTo(self.contentView).inset(20);
        }];
    }
    return _tipLabel;
}

- (UIView *)memoryWordView{
    if (!_memoryWordView) {
        _memoryWordView = [UIView new];
        [self.contentView addSubview:_memoryWordView];
        [_memoryWordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipLabel.mas_bottom).offset(5);
            make.left.right.equalTo(self.contentView).inset(10);
        }];
    }
    return _memoryWordView;
}

- (TCWalletSubTipView *)subTipView{
    if (!_subTipView) {
        _subTipView = [TCWalletSubTipView new];
        [self.contentView addSubview:_subTipView];
        [_subTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipLabel.mas_bottom).offset(20).priority(100);
            make.top.equalTo(self.memoryWordView.mas_bottom).offset(20).priority(200);
            make.centerX.equalTo(self.contentView);
            make.left.right.equalTo(self);
        }];
    }
    return _subTipView;
}

- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextButton.layer.cornerRadius = 22.5;
        [self.contentView addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView).inset(20);
            make.top.equalTo(self.subTipView.mas_bottom).offset(30);
            make.height.equalTo(@45);
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
    }
    return _nextButton;
}

@end
