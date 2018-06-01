//
//  TCMeNormalCell.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/15.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCMeNormalCell.h"
#import "TalkChainHeader.h"

@interface TCMeNormalCell()

@property (strong, nonatomic) UIImageView *titleImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *rightButton;
@property (copy, nonatomic) VoidBlock buttonBlock;

@end

@implementation TCMeNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];
        self.titleLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"cellTitle"];
    }
    return self;
}

- (void)cellWithTitleImage:(UIImage *)titleImage title:(NSString *)title rightImage:(UIImage *)rightImage rightButtonAction:(VoidBlock)buttonBlock{
    if (self.buttonBlock != buttonBlock) {
        self.buttonBlock = buttonBlock;
    }
    self.titleImageView.image = titleImage;
    self.titleLabel.text = title;
    [self.rightButton setImage:rightImage forState:UIControlStateNormal];
}


#pragma mark - 右按钮事件
- (void)rightButtonAction{
    if (self.buttonBlock) {
        self.buttonBlock();
    }
}

#pragma mark - lazyload
- (UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [UIImageView new];
        [self.contentView addSubview:_titleImageView];
        [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.inset(15);
            make.top.bottom.inset(15);
            make.width.height.equalTo(@20);
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
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _titleLabel;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.userInteractionEnabled = NO;
        [self.contentView addSubview:_rightButton];
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
            make.width.height.equalTo(@20);
        }];
        [_rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

@end
