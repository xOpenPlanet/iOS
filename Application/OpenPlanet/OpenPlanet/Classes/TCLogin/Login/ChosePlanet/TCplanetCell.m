//
//  TCplanetCell.m
//  
//
//  Created by YRH on 2018/4/20.
//  Copyright © 2018年 YRH. All rights reserved.
//

#import "TCPlanetCell.h"
#import "Masonry.h"

@interface TCPlanetCell ()

/// 星球视图
@property (nonatomic, strong) UIImageView *planetImageView;

@end

@implementation TCPlanetCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    [self.planetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

// 星球
- (UIImageView *)planetImageView {
    if (!_planetImageView) {
        _planetImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_planetImageView];
    }
    return _planetImageView;
}

- (void)setCellImage:(UIImage *)cellImage {
    _cellImage = cellImage;
    _planetImageView.image = cellImage;
}

@end
