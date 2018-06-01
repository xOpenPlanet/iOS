//
//  TCDiamondCell.m
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/23.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCDiamondCell.h"
#import "TalkChainHeader.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@interface TCDiamondCell()

@property (strong, nonatomic) FLAnimatedImageView *titleImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *balanceLabel;

@end

@implementation TCDiamondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];
        self.titleLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"accountColor" fromDictName:@"opMe"];
        self.balanceLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"balanceColor" fromDictName:@"opMe"];
    }
    return self;
}

- (void)cellWithTitleImagePath:(NSString *)titleImagePath title:(NSString *)title rightTitle:(NSString *)rightTitle cellType:(DiamondCellType)cellType{

    self.titleImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:titleImagePath]];
    self.titleLabel.text = title;

    switch (cellType) {
        case DiamondCellTypeNone:{
            self.balanceLabel.text = rightTitle;
            self.balanceLabel.font = FONT(14);
        }
            break;
        case DiamondCellTypeRefresh:{
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle =NSNumberFormatterDecimalStyle;
            NSString *newAmount = [formatter stringFromNumber:@([rightTitle integerValue])];
            self.balanceLabel.font = FONT(16);
            self.balanceLabel.text = newAmount;
        }
            break;
        default:
            break;
    }



}

#pragma mark - lazyload
- (FLAnimatedImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [FLAnimatedImageView new];
        _titleImageView.layer.cornerRadius = 25;
        _titleImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_titleImageView];
        [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.inset(15);
            make.left.inset(25);
            make.width.height.equalTo(@50);
        }];
    }
    return _titleImageView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT(17);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleImageView.mas_right).offset(10);
            make.centerY.equalTo(self.titleImageView).offset(0);
        }];
    }
    return _titleLabel;
}

- (UILabel *)balanceLabel{
    if (!_balanceLabel) {
        _balanceLabel = [UILabel new];
        _balanceLabel.font = FONT(16);
        [self.contentView addSubview:_balanceLabel];
        [_balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).inset(15);
        }];
    }
    return _balanceLabel;
}




@end
