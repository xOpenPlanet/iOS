//
//  TCInOutMiButton.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/22.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "TCInOutMiButton.h"
#import "TalkChainHeader.h"

@interface TCInOutMiButton ()

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *titleImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *leftLine;
@property (copy, nonatomic) VoidBlock tapBlock;

@end

@implementation TCInOutMiButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"titleColor" fromDictName:@"opMe"];
        self.leftLine.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"separatorColor" fromDictName:@"opMe"];

        // view点击事件回调
        [self ex_tapAction:^(UIGestureRecognizer *gestureRecoginzer) {
            if (self.tapBlock) {
                self.tapBlock();
            }
        }];
    }
    return self;
}


- (void)buttonWithImage:(UIImage *)image title:(NSString *)title isShowLeftLine:(BOOL)isShowLeftLine tap:(VoidBlock)tapBlock{
    if (self.tapBlock != tapBlock) {
        self.tapBlock = tapBlock;
    }
    self.titleImageView.image = image;
    self.titleLabel.text = title;
    self.leftLine.hidden = !isShowLeftLine;
}


#pragma mark - lazyload
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.bottom.equalTo(self).inset(15);
        }];
    }
    return _contentView;
}

- (UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [UIImageView new];
        [self.contentView addSubview:_titleImageView];
        [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.contentView);
            make.width.height.equalTo(@20);
        }];
    }
    return _titleImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT(16);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self.contentView);
            make.left.equalTo(self.titleImageView.mas_right);
        }];
    }
    return _titleLabel;
}

- (UIView *)leftLine{
    if (!_leftLine) {
        _leftLine = [UIView new];
        [self addSubview:_leftLine];
        [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.bottom.equalTo(self.contentView);
            make.width.equalTo(@(LINE_HEIGHT));
        }];
    }
    return _leftLine;
}

@end
