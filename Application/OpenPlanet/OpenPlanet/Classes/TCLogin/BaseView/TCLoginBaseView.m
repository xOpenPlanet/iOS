//
//  TCLoginBaseView.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/10.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCLoginBaseView.h"

@implementation TCLoginBaseView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.tipImageView.hidden = YES;
        self.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud" fromDictName:@"login"];
        self.contentView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cardBackgroud" fromDictName:@"login"];
        self.contentView.layer.theme_shadowColor = [UIColor theme_CGCcolorPickerForKey:@"cardShadowColor" fromDictName:@"login"];
        self.titleLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"titleColor" fromDictName:@"login"];
        self.tipLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"tipColor" fromDictName:@"login"];
        
        self.nextButton.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"nextButtonBgColor" fromDictName:@"login"];
        self.nextButton.theme_tintColor = [UIColor theme_colorPickerForKey:@"nextButtonTintColor" fromDictName:@"login"];
        [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        
        /// 添加键盘弹出关闭通知
        WEAK(self)
        //        [NOTIFICATIONCENTER addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        //            [weakself keyBoardIsShow:YES];
        //        }];
        //        [NOTIFICATIONCENTER addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        //            [weakself keyBoardIsShow:NO];
        //        }];
    }
    return self;
}

#pragma mark - 键盘出现关闭方法
//- (void)keyBoardIsShow:(BOOL)isShow{
//    CGFloat contentViewTopOffset = 50;
//    switch (CurrentDeviceType()) {
//        case IphoneXSize: contentViewTopOffset = 50;break;
//        case Iphone8plusSize: contentViewTopOffset = 80;break;
//        case Iphone8Size: contentViewTopOffset = 80;break;
//        case IphoneSESize: contentViewTopOffset = 120;break;
//        default:break;
//    }
//
//    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.topBgImageView.mas_bottom).offset(-(isShow?contentViewTopOffset:50));
//    }];
//
//    CGFloat avatarWidth = CurrentDeviceType() == IphoneSESize ? 60 : 90;
//    [self.tipImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@(isShow?avatarWidth:90));
//    }];
//
//    [UIView animateWithDuration:0.25 animations:^{
//        [self layoutIfNeeded];
//    }];
//}


- (void)dealloc{
    [NOTIFICATIONCENTER removeObserver:self];
}


#pragma mark - lazyload
- (UIImageView *)topBgImageView{
    if (!_topBgImageView) {
        _topBgImageView = [UIImageView new];
        [self addSubview:_topBgImageView];
        [_topBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(@(SCREEN_HEIGHT / 3.0));
        }];
    }
    return _topBgImageView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.shadowOffset = CGSizeMake(0,0);
        _contentView.layer.shadowRadius = 10.f;
        _contentView.layer.shadowOpacity = 0.6f;
        [self insertSubview:_contentView aboveSubview:self.topBgImageView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).inset(20);
            //            make.top.equalTo(self.topBgImageView.mas_bottom).offset(-50);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).inset(60);
                make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(40);
            } else {
                make.bottom.equalTo(self).inset(60);
                make.top.equalTo(self).offset(60);
            }
        }];
    }
    return _contentView;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _backButton.tintColor = cWhiteColor;
        [_backButton setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
        [self insertSubview:_backButton aboveSubview:self.topBgImageView];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.width.height.equalTo(@30);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(10);
            } else {
                make.top.equalTo(self).offset(30);
            }
        }];
    }
    return _backButton;
}

- (UIImageView *)tipImageView{
    if (!_tipImageView) {
        _tipImageView = [UIImageView new];
        _tipImageView.layer.cornerRadius = 10;
        _tipImageView.layer.masksToBounds = YES;
        [self insertSubview:_tipImageView aboveSubview:self.contentView];
        [_tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView.mas_top);
            make.width.height.equalTo(@90);
        }];
    }
    return _tipImageView;
}



- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = BOLD_FONT(17);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(20);
            make.top.equalTo(self.tipImageView.mas_bottom).offset(20);
        }];
    }
    return _titleLabel;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = FONT(13);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
        [self.contentView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        }];
    }
    return _tipLabel;
}

- (UIView *)customView{
    if (!_customView) {
        _customView = [UIView new];
        [self.contentView addSubview:_customView];
        [_customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipLabel.mas_bottom).offset(20).priority(200);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(20).priority(100);
            make.left.right.equalTo(self.titleLabel);
        }];
    }
    return _customView;
}


- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextButton.layer.cornerRadius = 22.5;
        [self.contentView addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.customView.mas_bottom).offset(40);
            make.height.equalTo(@45);
        }];
    }
    return _nextButton;
}

@end
