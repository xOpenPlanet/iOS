//
//  TCAddressCell.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/14.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCAddressCell.h"
#import "Masonry.h"
#import "ThemeKit.h"

@interface TCAddressCell()

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *tipImageView;

@end

@implementation TCAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];
        self.nameLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"cellTitle"];
    }
    return self;
}

- (void)cellWithAvatar:(UIImage *)avatar userName:(NSString *)userName tipImage:(UIImage *)tipImage{
    self.avatarImageView.image = avatar;
    self.nameLabel.text = userName;
    self.tipImageView.hidden = !(tipImage);
    if (tipImage) {
        self.tipImageView.image = tipImage;
    }
}

#pragma mark - lazyload
- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageView];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.inset(10);
            make.width.height.equalTo(@40);
        }];
    }
    return _avatarImageView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).offset(10);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _nameLabel;
}

- (UIImageView *)tipImageView{
    if (!_tipImageView) {
        _tipImageView = [UIImageView new];
        [self.contentView addSubview:_tipImageView];
        [_tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(self.nameLabel.mas_right).inset(5);
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.avatarImageView);
            make.width.height.equalTo(@15);
        }];
    }
    return _tipImageView;
}

@end
