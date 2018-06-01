//
//  TCMeHeaderView.m
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/23.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCMeHeaderView.h"
#import "TalkChainHeader.h"
#import "TCMeHeaderButton.h"
#import "EFAvatar.h"

@interface TCMeHeaderView()

/// 星球(不动)
@property (strong, nonatomic) UIImageView *backgroudImageView1;
/// 最外面的星云(逆时针旋转)
@property (strong, nonatomic) UIImageView *backgroudImageView2;
/// 星球周围(顺时针旋转)
@property (strong, nonatomic) UIImageView *backgroudImageView3;

/// 星际ID
@property (strong, nonatomic) UILabel *IdLabel;
/// 钱包账户
@property (strong, nonatomic) UILabel *accountLabel;
/// 复制图片
@property (strong, nonatomic) UIImageView *copyImage;
/// 头像
@property (strong, nonatomic) EFAvatar *avatarImageView;

@property (strong, nonatomic) UIImageView *bottomFrontImageView;

@property (strong, nonatomic) NSArray *itemButtons;

@end

@implementation TCMeHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
        self.backgroudImageView1.image = [UIImage theme_bundleImageNamed:@"me/me_header_bg1.png"]();
        self.backgroudImageView2.image = [UIImage theme_bundleImageNamed:@"me/me_header_bg2.png"]();
        self.backgroudImageView3.image = [UIImage theme_bundleImageNamed:@"me/me_header_bg3.png"]();
        
        
        self.nameLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"balanceColor" fromDictName:@"opMe"];
        self.IdLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"accountColor" fromDictName:@"opMe"];
        self.accountLabel.theme_textColor =  [UIColor theme_colorPickerForKey:@"accountColor" fromDictName:@"opMe"];
        self.copyImage.theme_image = [UIImage theme_bundleImageNamed:@"me/me_copy.png"];
        self.avatarImageView.image = [UIImage theme_bundleImageNamed:@"me/me_default_avatar.png"]();
        [self startAnimation];
    }
    return self;
}

- (void)headerWithAvatar:(NSString *)avatar
                    name:(NSString *)name
                  userId:(NSString *)userId
                 account:(NSString *)account
                  planet:(NSString *)planet
                   items:(NSArray<TCMeItemModel *> *)items{
    
    NSString *imageName = [NSString stringWithFormat:@"me/planet_bg/me_headerBg_%@.png",planet];
    UIImage *image = [UIImage theme_bundleImageNamed:imageName]();
    if (image) {
        self.backgroudImageView1.image = image;
    }
    
    [self.avatarImageView setAvatarWithUserId:[EnvironmentVariable getIMUserID] groupId:nil avatarUrl:avatar];
    
    self.nameLabel.text = name;
    self.IdLabel.text = [@"星际ID " stringByAppendingString:userId];
    
    
    if (account.length >= 16) {
        account = [account stringByReplacingCharactersInRange:NSMakeRange(6, account.length-10) withString:@"****"];
    }
    self.accountLabel.text = [@"基地ID " stringByAppendingString: account];
    
    NSMutableArray *buttons = [NSMutableArray array];
    WEAK(self)
    [items enumerateObjectsUsingBlock:^(TCMeItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TCMeHeaderButton *button = [TCMeHeaderButton new];
        [button buttonWithNum:obj.count title:obj.title touch:^{
            if (weakself.itemBlock) {
                weakself.itemBlock(obj);
            }
        }];
        [weakself addSubview:button];
        [buttons addObject:button];
    }];
    self.itemButtons = buttons;
    [buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(70);
        make.bottom.inset(15);
        make.height.equalTo(@50);
    }];
    
    
    /// 把底部阴影View移到最前面
    [self bringSubviewToFront:self.bottomFrontImageView];
}

- (void)reloadPlanet:(NSString *)planet{
    NSString *imageName = [NSString stringWithFormat:@"me/planet_bg/me_headerBg_%@.png",planet];
    UIImage *image = [UIImage theme_bundleImageNamed:imageName]();
    if (image) {
        self.backgroudImageView1.image = image;
    }
}


- (void)reloadItems:(NSArray<TCMeItemModel *> *)items{
    [self.itemButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TCMeHeaderButton *button = (TCMeHeaderButton *)obj;
        [button refreshButtonWithNum:items[idx].count title:items[idx].title];
    }];
}


#pragma mark - 用户信息点击事件
- (void)userInfoAciton{
    if (self.userInfoBlock) {
        self.userInfoBlock();
    }
}

- (void)copyAccount{
    if (self.copyAccountBlock) {
        self.copyAccountBlock();
    }
}


- (void)startAnimation{
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation1.fromValue = [NSNumber numberWithFloat:0.f];
    animation1.toValue = [NSNumber numberWithFloat: - M_PI * 2];
    animation1.duration = 240.0f;
    animation1.autoreverses = NO;
    animation1.removedOnCompletion = NO;
    animation1.fillMode = kCAFillModeForwards;
    animation1.repeatCount = MAXFLOAT;
    [self.backgroudImageView2.layer addAnimation:animation1 forKey:nil];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation2.fromValue = [NSNumber numberWithFloat:0.f];
    animation2.toValue = [NSNumber numberWithFloat: M_PI * 2];
    animation2.duration = 180.0f;
    animation2.autoreverses = NO;
    animation2.removedOnCompletion = NO;
    animation2.fillMode = kCAFillModeForwards;
    animation2.repeatCount = MAXFLOAT;
    [self.backgroudImageView3.layer addAnimation:animation2 forKey:nil];
}

#pragma mark - lazyload
- (UIImageView *)backgroudImageView1{
    if (!_backgroudImageView1) {
        _backgroudImageView1 = [UIImageView new];
        [self addSubview:_backgroudImageView1];
        [_backgroudImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_bottom).offset(SCREEN_WIDTH * 0.45);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH * 2.0);
            make.height.equalTo(_backgroudImageView1.mas_width);
        }];
    }
    return _backgroudImageView1;
}
- (UIImageView *)backgroudImageView2{
    if (!_backgroudImageView2) {
        _backgroudImageView2 = [UIImageView new];
        [self addSubview:_backgroudImageView2];
        [_backgroudImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.width.height.equalTo(self.backgroudImageView1);
        }];
    }
    return _backgroudImageView2;
}
- (UIImageView *)backgroudImageView3{
    if (!_backgroudImageView3) {
        _backgroudImageView3 = [UIImageView new];
        [self addSubview:_backgroudImageView3];
        [_backgroudImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.width.height.equalTo(self.backgroudImageView2);
        }];
    }
    return _backgroudImageView3;
}


- (EFAvatar *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [EFAvatar new];
        _avatarImageView.layer.cornerRadius = 35;
        _avatarImageView.layer.shadowColor = cBlackColor.CGColor;
        _avatarImageView.layer.shadowOffset = CGSizeMake(0, 0);
        _avatarImageView.layer.shadowOpacity = 1;
        _avatarImageView.layer.shadowRadius = 1;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
        [self addSubview:_avatarImageView];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.right.inset(15);
            make.width.height.equalTo(@70);
        }];
        
        [_avatarImageView ex_addTapGestureWithTarget:self action:@selector(userInfoAciton)];
    }
    return _avatarImageView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = FONT(18);
        _nameLabel.userInteractionEnabled = YES;
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView);
            make.left.offset(15);
            make.right.equalTo(self.avatarImageView.mas_left).offset(-10);
        }];
        [_nameLabel ex_addTapGestureWithTarget:self action:@selector(userInfoAciton)];
    }
    return _nameLabel;
}
- (UILabel *)IdLabel{
    if (!_IdLabel) {
        _IdLabel = [UILabel new];
        _IdLabel.font = FONT(15);
        _IdLabel.userInteractionEnabled = YES;
        [self addSubview:_IdLabel];
        [_IdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.right.equalTo(self.nameLabel);
        }];
        [_IdLabel ex_addTapGestureWithTarget:self action:@selector(userInfoAciton)];
    }
    return _IdLabel;
}

- (UILabel *)accountLabel{
    if (!_accountLabel) {
        _accountLabel = [UILabel new];
        _accountLabel.font = FONT(15);
        _accountLabel.userInteractionEnabled = YES;
        [self addSubview:_accountLabel];
        [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.IdLabel.mas_bottom);
            make.left.equalTo(self.IdLabel);
            make.height.equalTo(@25);
        }];
        [_accountLabel ex_addTapGestureWithTarget:self action:@selector(copyAccount)];
    }
    return _accountLabel;
}


- (UIImageView *)copyImage{
    if (!_copyImage) {
        _copyImage = [UIImageView new];
        _copyImage.userInteractionEnabled = YES;
        [self addSubview:_copyImage];
        [_copyImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.accountLabel);
            make.left.equalTo(self.accountLabel.mas_right);
            make.width.height.equalTo(@15);
        }];
        [_copyImage ex_addTapGestureWithTarget:self action:@selector(copyAccount)];
    }
    return _copyImage;
}

- (UIImageView *)bottomFrontImageView{
    if (!_bottomFrontImageView) {
        _bottomFrontImageView = [UIImageView new];
        _bottomFrontImageView.image = [UIImage theme_bundleImageNamed:@"me/me_header_bottom.png"]();
        [self addSubview:_bottomFrontImageView];
        [_bottomFrontImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@80);
        }];
    }
    return _bottomFrontImageView;
}


- (NSArray *)itemButtons{
    if (!_itemButtons) {
        _itemButtons = [NSArray array];
    }
    return _itemButtons;
}
@end

