//
//  LeftHeaderView.h
//  ESPChatComps
//
//  Created by 于仁汇 on 16/9/20.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFAvatar.h"

@interface LeftHeaderView : UIView

@property (nonatomic, strong) EFAvatar *headImageView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *remarkLB;
@property (nonatomic, strong) UIImageView *QRCodeImg;
@property (nonatomic, strong) UIImageView *genderImg;
@property (nonatomic, strong) UIImageView *jsImage;
/// 赋值
- (void)setInfoForView:(NSString *)imageName title:(NSString *)title remark:(NSString *)remark QRCodeImg:(UIImage *)QRCodeImg textColor:(UIColor *)textColor textFont:(UIFont *)font gender:(NSString *)gender;

- (void)setInfoForView:(NSString *)imageName title:(NSString *)title remark:(NSString *)remark QRCodeImg:(UIImage *)QRCodeImg textColor:(UIColor *)textColor textFont:(UIFont *)font gender:(NSString *)gender jsImage:(NSString *)jsImage;

/// 一般赋值
- (void)commonSetInfoForViewWithUserId:(NSString *)userId imageUrl:(NSString *)imageName title:(NSString *)title remark:(NSString *)remark QRCodeImg:(UIImage *)QRCodeImg textColor:(UIColor *)textColor textFont:(UIFont *)font gender:(NSString *)gender;

@end
