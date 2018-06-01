//
//  TCOutMiResultView.m
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/24.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCOutMiResultView.h"
#import "TalkChainHeader.h"

@interface TCOutMiResultView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *middleLine;
@property (strong, nonatomic) UILabel *contentLabel;


@end

@implementation TCOutMiResultView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];
        self.titleLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"cellTitle"];
        self.contentLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"cellTitle"];
        self.middleLine.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"separatorColor"];
    }
    return self;
}

- (void)viewWithTitle:(NSString *)title content:(NSString *)content isShowMiddleLine:(BOOL)isShow{
    self.middleLine.hidden = !isShow;
    self.titleLabel.text = title;
    self.contentLabel.text = content;


    if (isShow) {
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.middleLine.mas_bottom).offset(10);
            make.left.right.bottom.equalTo(self).insets(UIEdgeInsetsMake(0, 20, 10, 20));
        }];
    }else{
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.left.right.bottom.equalTo(self).insets(UIEdgeInsetsMake(0, 20, 10, 20));
        }];

    }

}

#pragma mark - lazyload
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self).insets(UIEdgeInsetsMake(10, 20, 0, 20));
        }];
    }
    return _titleLabel;
}


- (UIView *)middleLine{
    if (!_middleLine) {
        _middleLine = [UIView new];
        [self addSubview:_middleLine];
        [_middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.left.right.equalTo(self).inset(20);
            make.height.equalTo(@(LINE_HEIGHT));
        }];
    }
    return _middleLine;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = cLightGrayColor;
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.middleLine.mas_bottom).offset(10);
            make.left.right.bottom.equalTo(self).insets(UIEdgeInsetsMake(0, 20, 10, 20));
        }];
    }
    return _contentLabel;
}
@end
