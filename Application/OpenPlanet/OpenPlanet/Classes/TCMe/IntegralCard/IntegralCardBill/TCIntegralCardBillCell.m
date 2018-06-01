//
//  TCIntegralCardBillCell.m
//  TalkChain
//
//  Created by 王胜利 on 2018/4/14.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "TCIntegralCardBillCell.h"
#import "TalkChainHeader.h"

@interface TCIntegralCardBillCell ()

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *reasonLabel;
@property (strong, nonatomic) UILabel *integralLabel;

@end

@implementation TCIntegralCardBillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"contentBackgroud"];
        self.contentView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"contentBackgroud"];
        self.timeLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"cellTitle"];
        self.reasonLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"cellTitle"];
    }
    return self;
}

- (void)cellWithTime:(NSString *)time integral:(NSString *)integral reason:(NSString *)reason{
    self.reasonLabel.text = reason;
    self.timeLabel.text = time;
    self.integralLabel.text = integral;
}

#pragma mark - lazyload
- (UILabel *)reasonLabel{
    if (!_reasonLabel) {
        _reasonLabel = [UILabel new];
        _reasonLabel.font = FONT(15);
        [self.contentView addSubview:_reasonLabel];
        [_reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.inset(15);
        }];
    }
    return _reasonLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = FONT(13);
//        _timeLabel.textColor = cLightGrayColor;
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reasonLabel.mas_bottom).offset(5);
            make.left.bottom.inset(15);
        }];
    }
    return _timeLabel;
}

- (UILabel *)integralLabel{
    if (!_integralLabel) {
        _integralLabel = [UILabel new];
        _integralLabel.font = FONT(15);
        _integralLabel.textColor = TCTipColor;
        [self.contentView addSubview:_integralLabel];
        [_integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.inset(15);
            make.top.bottom.inset(15);
        }];
    }
    return _integralLabel;
}

@end
