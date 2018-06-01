//
//  TCMemoryRecoverWalletView.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/28.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "TCMemoryRecoverWalletView.h"
#import "TalkChainHeader.h"

@implementation TCMemoryRecoverWalletView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self loadMemoryView];
        self.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud" fromDictName:@"wallet"];
        self.tipLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"backUpTipColor" fromDictName:@"wallet"];
        self.nextButton.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"nextButtonBgColor" fromDictName:@"login"];
        self.nextButton.theme_tintColor = [UIColor theme_colorPickerForKey:@"nextButtonTintColor" fromDictName:@"login"];

        /// 添加键盘弹出关闭通知
        WEAK(self)
        [NOTIFICATIONCENTER addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            NSDictionary *userInfo = [note userInfo];
            NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
            CGRect keyboardRect = [aValue CGRectValue];
            int height = keyboardRect.size.height;


            UIView *firstResponder =  [self findFirstResponder];
            CGFloat lineIdx = 0;
            if (firstResponder) {
                NSInteger index = firstResponder.tag - 100;
                if (lineIdx > 3) {
                    lineIdx = floor((CGFloat)index / 2);
                }
            }

            CGFloat offsetY = lineIdx * 50 +  50;
            [weakself keyBoardWithKeyboardHeight:height offsetY:offsetY];
        }];
        [NOTIFICATIONCENTER addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [weakself keyBoardWithKeyboardHeight:0 offsetY:0];
        }];
    }
    return self;
}

- (UIView *)findFirstResponder{
    for (UIView *view in self.memoryWordView.subviews) {
        if ([view isKindOfClass:[UITextField class]] && view.isFirstResponder) {
            return view;
        }
    }
    return nil;
}

#pragma mark - 键盘出现关闭方法
- (void)keyBoardWithKeyboardHeight:(CGFloat)keyboardHeight offsetY:(CGFloat)offsetY{
    [self.nextButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-(keyboardHeight+20));
    }];

    self.contentOffset = CGPointMake(0, offsetY);

    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)dealloc{
    [NOTIFICATIONCENTER removeObserver:self];
}

- (void)loadMemoryView{
    NSInteger allCount = 12;
    /// 列数
    NSInteger columnNum = 2;
    /// 行数(向上取整)
    NSInteger lineNum = ceilf((CGFloat)allCount/columnNum);
    /// item高度
    CGFloat itemHeight = 40;
    /// 间隔
    CGFloat space = 10;
    /// item宽
    CGFloat itemWidth = (SCREEN_WIDTH - 20 - space*(columnNum + 1)) / columnNum;


    for (int i = 0; i < allCount; i ++) {
        /// 第几列
        NSInteger columnIdx = i % columnNum;
        /// 第几行
        NSInteger lineIdx = floor((CGFloat)i / columnNum);

        UIView *lastView;
        if (self.memoryWordView.subviews.count > 0) {
            lastView = self.memoryWordView.subviews.lastObject;
        }

        UITextField *textField = [UITextField new];
        textField.tag = 100 + i;
        textField.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"tipColor" fromDictName:@"login"];
        textField.textColor = cWhiteColor;
        textField.font = BOLD_FONT(17);
        textField.returnKeyType = (i == allCount-1)?UIReturnKeyDone:UIReturnKeyNext;
        //        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [self.memoryWordView addSubview:textField];


        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = cWhiteColor;
        [textField addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(textField).offset(-10);
            make.height.equalTo(@1);
            make.left.equalTo(textField).offset(30);
            make.bottom.equalTo(textField).offset(-5);
        }];

        UILabel *label = [UILabel new];
        label.text = [NSString stringWithFormat:@"%d.",i+1];
        label.frame = CGRectMake(0, 0, 30, itemHeight-10);
        label.textAlignment = NSTextAlignmentCenter;
        textField.font = FONT(17);
        label.textColor = RGB(231, 86, 0);
        textField.leftView = label;
        textField.leftViewMode = UITextFieldViewModeAlways;

        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
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
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = FONT(16);
        _tipLabel.numberOfLines = 0;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self).inset(20);
            make.centerX.equalTo(self);
        }];
    }
    return _tipLabel;
}

- (UIView *)memoryWordView{
    if (!_memoryWordView) {
        _memoryWordView = [UIView new];
        [self addSubview:_memoryWordView];
        [_memoryWordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipLabel.mas_bottom).offset(5);
            make.left.right.equalTo(self).inset(10);
            make.centerX.equalTo(self);
        }];
    }
    return _memoryWordView;
}

- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextButton.layer.cornerRadius = 22.5;
        [self addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).inset(20);
            make.top.equalTo(self.memoryWordView.mas_bottom).offset(30);
            make.height.equalTo(@45);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-20);
        }];
    }
    return _nextButton;
}

@end
