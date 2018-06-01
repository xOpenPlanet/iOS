//
//  TCMeHeaderButton.m
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/24.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCMeHeaderButton.h"

@interface TCMeHeaderButton ()
/// 按钮数目
@property (strong, nonatomic) UILabel *numLabel;
/// 按钮标题
@property (strong, nonatomic) UILabel *titleLabel;

@property (copy, nonatomic) VoidBlock touchBlock;

@end
@implementation TCMeHeaderButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.numLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"headerButtonColor" fromDictName:@"opMe"];
        self.titleLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"headerButtonColor" fromDictName:@"opMe"];
        // view点击事件回调
        [self ex_tapAction:^(UIGestureRecognizer *gestureRecoginzer) {
            if (self.touchBlock) {
                self.touchBlock();
            }
        }];
    }
    return self;
}

- (void)buttonWithNum:(NSString *)num title:(NSString *)title touch:(VoidBlock)touchBlock{
    if (self.touchBlock != touchBlock) {
        self.touchBlock = touchBlock;
    }
    self.numLabel.text = SafeString(num);
    self.titleLabel.text = SafeString(title);
}

- (void)refreshButtonWithNum:(NSString *)num title:(NSString *)title{
    self.numLabel.text = SafeString(num);
    self.titleLabel.text = SafeString(title);
}


#pragma mark - lazyload
- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.font = FONT(18);
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.layer.shadowColor = cBlackColor.CGColor;
        _numLabel.layer.shadowOffset = CGSizeMake(1, 1);
        _numLabel.layer.shadowOpacity = 0.5;
        _numLabel.layer.shadowRadius = 2;
        [self addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
        }];
    }
    return _numLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT(15);
        _titleLabel.layer.shadowColor = cBlackColor.CGColor;
        _titleLabel.layer.shadowOffset = CGSizeMake(1, 1);
        _titleLabel.layer.shadowOpacity = 0.5;
        _titleLabel.layer.shadowRadius = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.numLabel.mas_bottom).offset(5);
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(self.numLabel);
        }];
    }
    return _titleLabel;
}


@end
