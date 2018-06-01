//
//  TCSureMemoryView.m
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/26.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCSureMemoryView.h"

#define kSpace 20

@implementation TCSureMemoryView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.subTitleLabel.theme_textColor  = [UIColor theme_colorPickerForKey:@"titleColor" fromDictName:@"wallet"];
        self.tipLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"tipColor" fromDictName:@"login"];
        self.nextButton.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"nextButtonBgColor" fromDictName:@"login"];
        self.nextButton.theme_tintColor = [UIColor theme_colorPickerForKey:@"nextButtonTintColor" fromDictName:@"login"];
        self.selectedMemeoryWordView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud" fromDictName:@"login"];

    }
    return self;
}

- (void)setSelectedMemoryWords:(NSArray *)selectedMemoryWords{
    _selectedMemoryWords = selectedMemoryWords;

    for (UIView *subView in self.selectedMemeoryWordView.subviews) {
        [subView removeFromSuperview];
    }

    CGFloat labelSpace = 10;
    CGFloat labelHeight = 40;
    CGFloat maxWidth = SCREEN_WIDTH - kSpace * 2 - labelSpace * 2;

    NSUInteger i = 0;
    for (NSString *word in selectedMemoryWords) {
        UIView *lastView = self.selectedMemeoryWordView.subviews.lastObject;

        UILabel *label = [UILabel new];
        label.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"tipColor" fromDictName:@"login"];
        label.textColor = cWhiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(17);
        label.text = [NSString stringWithFormat:@"%ld.%@",i+1,word];
        label.userInteractionEnabled = YES;
        [self.selectedMemeoryWordView addSubview:label];
        WEAK(self)
        [label ex_tapAction:^(UIGestureRecognizer *gestureRecoginzer) {
            if (weakself.selectedMemoryWordTapAction) {
                weakself.selectedMemoryWordTapAction(word,i);
            }
        }];

        CGFloat labelWidth = (maxWidth - labelSpace)/2;
//        CGFloat labelWidth = [word boundingRectWithSize:CGSizeMake(maxWidth, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(17)} context:nil].size.width + 10;
        if (lastView) {
            if (CGRectGetMaxX(lastView.frame)  > (maxWidth /2.0 + labelSpace)) {
                label.frame = CGRectMake(labelSpace, CGRectGetMaxY(lastView.frame) + labelSpace, labelWidth, labelHeight);
            }else{
                label.frame = CGRectMake(CGRectGetMaxX(lastView.frame) + labelSpace, CGRectGetMinY(lastView.frame), labelWidth, labelHeight);
            }
        }else{
            label.frame = CGRectMake(labelSpace, labelSpace, labelWidth, labelHeight);
        }
        i++;
    }

    UIView *lastView = self.selectedMemeoryWordView.subviews.lastObject;
    if (lastView) {
        CGFloat lastY =  CGRectGetMaxY(lastView.frame) + labelSpace;
        [self.selectedMemeoryWordView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.greaterThanOrEqualTo(@(lastY));
        }];
    }else{
        [self.selectedMemeoryWordView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.greaterThanOrEqualTo(@50);
        }];
    }
}

- (void)setNoSelectMemoryWords:(NSArray *)noSelectMemoryWords{
    _noSelectMemoryWords = noSelectMemoryWords;

    for (UIView *subView in self.noSelectMemoryWordView.subviews) {
        [subView removeFromSuperview];
    }


    CGFloat labelSpace = 10;
    CGFloat labelHeight = 30;
    CGFloat maxWidth = SCREEN_WIDTH - kSpace * 2;
    NSInteger i = 0;
    for (NSString *word in noSelectMemoryWords) {

        UIView *lastView = self.noSelectMemoryWordView.subviews.lastObject;

        UILabel *label = [UILabel new];
        label.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cardBackgroud" fromDictName:@"login"];
        label.textColor = cWhiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(17);
        label.text = word;
        label.userInteractionEnabled = YES;
        [self.noSelectMemoryWordView addSubview:label];
        WEAK(self)
        [label ex_tapAction:^(UIGestureRecognizer *gestureRecoginzer) {
            if (weakself.noSelectMemoryWordTapAction) {
                weakself.noSelectMemoryWordTapAction(word,i);
            }
        }];
        CGFloat labelWidth = [word boundingRectWithSize:CGSizeMake(maxWidth, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(17)} context:nil].size.width + 10;
        if (lastView) {
            if (CGRectGetMaxX(lastView.frame) + labelSpace + labelWidth > maxWidth) {
                label.frame = CGRectMake(0, CGRectGetMaxY(lastView.frame) + labelSpace, labelWidth, labelHeight);
            }else{
                label.frame = CGRectMake(CGRectGetMaxX(lastView.frame) + labelSpace, CGRectGetMinY(lastView.frame), labelWidth, labelHeight);
            }
        }else{
            label.frame = CGRectMake(0, 0, labelWidth, labelHeight);
        }
        i++;
    }


    UIView *lastView = self.noSelectMemoryWordView.subviews.lastObject;
    if (lastView) {
        CGFloat lastY =  CGRectGetMaxY(lastView.frame);
        [self.noSelectMemoryWordView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.greaterThanOrEqualTo(@(lastY));
        }];
    }else{
        [self.noSelectMemoryWordView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.greaterThanOrEqualTo(@5);
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

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.font = BOLD_FONT(17);
        _subTitleLabel.textColor = cTextColor;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_subTitleLabel];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(kSpace);
            make.left.right.equalTo(self.contentView).inset(kSpace);
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
            make.left.right.equalTo(self.contentView).inset(kSpace);
        }];
    }
    return _tipLabel;
}

- (UIView *)selectedMemeoryWordView{
    if (!_selectedMemeoryWordView) {
        _selectedMemeoryWordView = [UIView new];
        [self.contentView addSubview:_selectedMemeoryWordView];
        [_selectedMemeoryWordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipLabel.mas_bottom).offset(5);
            make.left.right.equalTo(self.contentView).inset(kSpace);
            make.height.greaterThanOrEqualTo(@50);
        }];
    }
    return _selectedMemeoryWordView;
}

- (UIView *)noSelectMemoryWordView{
    if (!_noSelectMemoryWordView) {
        _noSelectMemoryWordView = [UIView new];
        [self.contentView addSubview:_noSelectMemoryWordView];
        [_noSelectMemoryWordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectedMemeoryWordView.mas_bottom).offset(20);
            make.left.right.equalTo(self.contentView).inset(kSpace);
            make.height.greaterThanOrEqualTo(@5);
        }];
    }
    return _noSelectMemoryWordView;
}


- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextButton.layer.cornerRadius = 22.5;
        [self.contentView addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView).inset(kSpace);
            make.top.equalTo(self.noSelectMemoryWordView.mas_bottom).offset(30);
            make.height.equalTo(@45);
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-kSpace);
        }];
    }
    return _nextButton;
}


@end
