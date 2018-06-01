//
//  TCWalletCell.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/31.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "TCWalletCell.h"
#import "TCInOutMiButton.h"
#import "TCMeNormalCell.h"
#import "UIImage+GIF.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

#define kEnergyAnimationTime 1.0f
#define kEnergyBackContinueTime 3.0f

@interface TCWalletCell ()

/// 能量币图片
@property (strong, nonatomic) FLAnimatedImageView *energyCoinImageView;
/// 能量标题
@property (strong, nonatomic) UILabel *energyTitleLabel;
/// 能量
@property (strong, nonatomic) UILabel *energyLabel;
/// 钱包账户余额
//@property (strong, nonatomic) UILabel *accountBalanceLabel;
/// 转出
@property (strong, nonatomic) TCInOutMiButton *inButton;
/// 转入
@property (strong, nonatomic) TCInOutMiButton *outButton;
/// 交易详情
@property (strong, nonatomic) TCMeNormalCell *transactionView;

@property (copy, nonatomic) VoidBlock transDetailBlock;


/// 是否在翻转中
@property (assign, nonatomic) BOOL isCoinAnimation;
/// 0.正面 1.正转反 2.反面 3.反转正
@property (assign, nonatomic) NSInteger energyType;


@end


@implementation TCWalletCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];
        self.contentView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];
        self.energyTitleLabel.theme_textColor =  [UIColor theme_colorPickerForKey:@"titleColor" fromDictName:@"opMe"];
        self.energyLabel.theme_textColor =  [UIColor theme_colorPickerForKey:@"titleColor" fromDictName:@"opMe"];
        //        self.accountBalanceLabel.theme_textColor =  [UIColor theme_colorPickerForKey:@"accountColor" fromDictName:@"opMe"];
        self.energyType = 0;
        self.energyCoinImageView.animatedImage = [self energyFLAnimationImage];
    }
    return self;
}

#pragma mark - 根据状态获取图片
- (FLAnimatedImage *)energyFLAnimationImage{
    NSString *imageName = @"me_energy_front.gif";
    switch (self.energyType) {
        case 0:imageName = @"me_energy_front.gif";break;
        case 1:imageName = @"me_energy_frontToBack.gif";break;
        case 2:imageName = @"me_energy_back.gif";break;
        case 3:imageName = @"me_energy_backToFront.gif";break;
        default:
            break;
    }
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@/image/me/%@",ThemeBundlePath,[ThemeManager getCurrentThemeName],imageName];
    return  [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:imagePath]];
}


#pragma mark - 能量按钮点击事件
- (void)energyTouchAction{
    WEAK(self)
    if (self.energyType == 0) {
        // 1.进入正转反
        self.energyType = 1;
        self.isCoinAnimation = YES;
        self.energyCoinImageView.animatedImage = [self energyFLAnimationImage];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kEnergyAnimationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 2.进入反面
            weakself.energyType = 2;
            weakself.isCoinAnimation = NO;
            self.energyCoinImageView.animatedImage = [self energyFLAnimationImage];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kEnergyBackContinueTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!weakself.isCoinAnimation && weakself.energyType == 2) {
                    // 3.进入反转正
                    [weakself energyImageBackToFront];
                }
            });
            
        });
    }else if (self.energyType == 2){
        [self energyImageBackToFront];
    }
}


#pragma mark - 能量图标反转正
- (void)energyImageBackToFront{
    // 1.进入反转正
    self.energyType = 3;
    self.isCoinAnimation = YES;
    self.energyCoinImageView.animatedImage = [self energyFLAnimationImage];
    WEAK(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kEnergyAnimationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2.进入正面
        weakself.isCoinAnimation = NO;
        weakself.energyType = 0;
        self.energyCoinImageView.animatedImage = [self energyFLAnimationImage];
    });
}



#pragma mark - 赋值Cell
- (void)cellWithWalletModel:(TCWalletModel *)model outMi:(VoidBlock)outMiBlock inMi:(VoidBlock)inMiBlock transDetail:(VoidBlock)transDetailBlock{
    if (self.transDetailBlock != transDetailBlock) {
        self.transDetailBlock = transDetailBlock;
    }
    self.energyTitleLabel.text = model.energyCoinTitle;
    
    if ([model.energyCoinBalance isEqualToString:@"0"]) {
        self.energyLabel.text = model.energyCoinBalance;
    }else{
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle =NSNumberFormatterDecimalStyle;
        NSNumber *num = @([model.energyCoinBalance longLongValue]);
        NSString *firstBalance = [formatter stringFromNumber:num];
        
        NSRange range = [model.energyCoinBalance rangeOfString:@"."];
        NSString *secondBalance = [model.energyCoinBalance substringFromIndex:range.location+1];
        
        self.energyLabel.text = [NSString stringWithFormat:@"%@.%@",firstBalance,secondBalance];;
    }
    
    
    //    NSString *newAccountBalance = [formatter stringFromNumber:@([model.accountBalance doubleValue])];
    //    self.accountBalanceLabel.text = [NSString stringWithFormat:@"¥ %@",model.accountBalance] ;
    
    [self.inButton buttonWithImage:model.inMiImage title:model.inMiTitle isShowLeftLine:YES tap:inMiBlock];
    [self.outButton buttonWithImage:model.outMiImage title:model.outMiTitle isShowLeftLine:NO tap:outMiBlock];
    [self.transactionView cellWithTitleImage:model.transMiImage title:model.transMiTitle rightImage:model.transMiRightImage rightButtonAction:nil];
}


#pragma mark - 查看交易详情
- (void)transAction{
    if (self.transDetailBlock) {
        self.transDetailBlock();
    }
}


#pragma mark - lazyload
- (FLAnimatedImageView *)energyCoinImageView{
    if (!_energyCoinImageView) {
        _energyCoinImageView = [FLAnimatedImageView new];
        _energyCoinImageView.layer.cornerRadius = 35;
        _energyCoinImageView.layer.masksToBounds = YES;
        _energyCoinImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_energyCoinImageView];
        [_energyCoinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.inset(15);
            make.left.inset(15);
            make.width.height.equalTo(@70);
        }];
        
        [_energyCoinImageView ex_addTapGestureWithTarget:self action:@selector(energyTouchAction)];
    }
    return _energyCoinImageView;
}
- (UILabel *)energyTitleLabel{
    if (!_energyTitleLabel) {
        _energyTitleLabel = [UILabel new];
        _energyTitleLabel.font = FONT(16);
        [self.contentView addSubview:_energyTitleLabel];
        [_energyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.energyCoinImageView.mas_right).offset(10);
            make.centerY.equalTo(self.energyCoinImageView);
        }];
    }
    return _energyTitleLabel;
}


- (UILabel *)energyLabel{
    if (!_energyLabel) {
        _energyLabel = [UILabel new];
        _energyLabel.font = FONT(18);
        [self.contentView addSubview:_energyLabel];
        [_energyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.energyTitleLabel);
            make.right.inset(15);
        }];
    }
    return _energyLabel;
}

//- (UILabel *)accountBalanceLabel{
//    if (!_accountBalanceLabel) {
//        _accountBalanceLabel = [UILabel new];
//        _accountBalanceLabel.font = FONT(18);
//        [self.contentView addSubview:_accountBalanceLabel];
//        [_accountBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.energyLabel);
//            make.bottom.equalTo(self.energyCoinImageView).offset(-8);
//        }];
//    }
//    return _accountBalanceLabel;
//}

- (TCInOutMiButton *)outButton{
    if (!_outButton) {
        UIView *line = [UIView new];
        line.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"separatorColor" fromDictName:@"opMe"];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.energyCoinImageView);
            make.right.equalTo(self.contentView);
            make.height.equalTo(@(LINE_HEIGHT));
            make.top.equalTo(self.energyCoinImageView.mas_bottom).offset(15);
        }];
        
        _outButton = [TCInOutMiButton new];
        [self.contentView addSubview:_outButton];
        [_outButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom);
            make.left.equalTo(self.energyCoinImageView);
        }];
    }
    return _outButton;
}

- (TCInOutMiButton *)inButton{
    if (!_inButton) {
        _inButton = [TCInOutMiButton new];
        [self.contentView addSubview:_inButton];
        [_inButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(self.outButton);
            make.left.equalTo(self.outButton.mas_right);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
    return _inButton;
}

- (TCMeNormalCell *)transactionView{
    if (!_transactionView) {
        UIView *line = [UIView new];
        line.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"separatorColor" fromDictName:@"opMe"];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.inset(15);
            make.right.equalTo(self.contentView);
            make.height.equalTo(@(LINE_HEIGHT));
            make.top.equalTo(self.outButton.mas_bottom);
        }];
        
        _transactionView = [TCMeNormalCell new];
        [self.contentView addSubview:_transactionView.contentView];
        [_transactionView.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom);
            make.left.right.bottom.equalTo(self.contentView);
        }];
        
        [_transactionView.contentView ex_addTapGestureWithTarget:self action:@selector(transAction)];
        
    }
    return _transactionView;
}




@end
