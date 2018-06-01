//
//  TCAddressDetailCell.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/15.
//  Copyright © 2018年 wsl. All rights reserved.
//  联系人电话Cell

#import "TCAddressDetailCell.h"
#import "TalkChainHeader.h"

@interface TCAddressDetailCell ()

/// 号码标签Label
@property (strong, nonatomic) UILabel *phoneTipLabel;
/// 号码Label
@property (strong, nonatomic) UILabel *phoneLabel;
/// 分割线
@property (strong, nonatomic) UIView *lineView;

@end

@implementation TCAddressDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self lineView];
    }
    return self;
}

- (void)cellWithPhone:(NSString *)phone phoneTip:(NSString *)phoneTip{
    self.phoneLabel.text = phone;
    self.phoneTipLabel.text = phoneTip;
}

#pragma mark - lazyload
- (UILabel *)phoneTipLabel{
    if (!_phoneTipLabel) {
        _phoneTipLabel = [UILabel new];
        _phoneTipLabel.font = FONT(13);
        _phoneTipLabel.textColor = TCTipColor;
        [self.contentView addSubview:_phoneTipLabel];
        [_phoneTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).inset(10);
        }];
    }
    return _phoneTipLabel;
}

- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        _phoneLabel.font = FONT(16);
        _phoneLabel.numberOfLines = 0;
        _phoneLabel.textColor = cTextColor;
        [self.contentView addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneTipLabel.mas_bottom);
            make.left.bottom.right.equalTo(self.contentView).inset(10);
        }];
    }
    return _phoneLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = HEX_COLOR(0xcccccc);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(10);
            make.height.equalTo(@(LINE_HEIGHT));
            make.bottom.equalTo(self.contentView);
        }];
    }
    return _lineView;
}


@end
