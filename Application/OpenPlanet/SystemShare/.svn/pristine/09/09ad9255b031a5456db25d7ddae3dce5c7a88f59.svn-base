//
//  SystemShareCell.m
//  SystemShare
//
//  Created by 高建飞 on 2018/5/31.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "SystemShareCell.h"
#import "Masonry.h"

@interface SystemShareCell()

@property (nonatomic, strong) UIImageView *iconImageView; // 左侧图标
@property (nonatomic, strong) UILabel *titleLabel; // 标题

@end

@implementation SystemShareCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    }
    return self;
}

- (void) cellDataWithDataDictionary:(NSDictionary *)dataDictionary {
    if(dataDictionary[@"title"]){
        self.titleLabel.text = dataDictionary[@"title"];
    }
    if(dataDictionary[@"icon"]) {
        self.iconImageView.image = [UIImage imageNamed:dataDictionary[@"icon"]];
    }
}

- (UIImageView *) iconImageView {
    if(!_iconImageView) {
        _iconImageView = [UIImageView new];
        [self.contentView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(10);
            make.width.height.mas_equalTo(30);
        }];
    }
    return _iconImageView;
}

- (UILabel *) titleLabel {
    if(!_titleLabel) {
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.iconImageView.mas_right).with.offset(10);
            make.right.equalTo(self).inset(10);
            make.height.mas_equalTo(30);
        }];
    }
    return _titleLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
