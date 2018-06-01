//
//  SystemShareImageDisplayView.m
//  Zone
//
//  Created by 王胜利 on 2018/5/30.
//  Copyright © 2018年 pansoft. All rights reserved.
//

#import "SystemShareImageDisplayView.h"
#import "Masonry.h"

#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width

@interface SystemShareImageDisplayView()

@property (strong, nonatomic) UIView *backView;

@end

@implementation SystemShareImageDisplayView

- (void)viewWithImageUrls:(NSArray *)imageUrls{

    [self.backView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];

    NSArray *showImages = imageUrls.count>9?[imageUrls subarrayWithRange:NSMakeRange(0, 9)]:imageUrls;

    /// 列数
    NSInteger columnNum = 3;
    /// 行数(向上取整)
    NSInteger lineNum = ceilf((CGFloat)showImages.count/columnNum);
    /// 左右间距
    CGFloat leftRightSpace = 10;
    /// 行间距
    CGFloat itemSpace = 5;
    /// item宽度
    CGFloat itemWidth =([UIScreen mainScreen].bounds.size.width-leftRightSpace*2 - (columnNum-1)*itemSpace)/columnNum;;
    /// item高度
    CGFloat itemHeight = itemWidth;
    /// 当前View高度
    CGFloat contentViewHeight = lineNum * itemHeight + (lineNum-1)*itemSpace;
    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(contentViewHeight));
    }];


    /// 添加按钮
    [showImages enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        /// 第几列
        NSInteger columnIdx = idx % columnNum;
        /// 第几行
        NSInteger lineIdx = floor((CGFloat)idx / columnNum);
        /// x坐标
        CGFloat objX = columnIdx * (itemWidth + itemSpace) + leftRightSpace;
        /// y坐标
        CGFloat objY = lineIdx * (itemHeight + itemSpace);

        UIImageView *imageView = [UIImageView new];
        imageView.frame = CGRectMake(objX, objY, itemWidth, itemHeight);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        imageView.layer.masksToBounds = YES;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj]];
        imageView.image = [UIImage imageWithData:data];
        imageView.tag = 1000 + idx;
        [self.backView addSubview:imageView];
    }];
}
#pragma mark - lazyload
- (UIView *)backView{
    if (!_backView) {
        _backView = [UIView new];
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.bottom.inset(10);
            make.height.equalTo(@(0));
        }];
    }
    return _backView;
}

@end
