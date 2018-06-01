//
//  TCMeSurePasswordController.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/15.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PasswordRightBlock)(BOOL isSuccess,NSString *password);

@interface TCSurePasswordController : UIViewController


/// 灰色透明蒙版
@property (strong, nonatomic) UIView *maskView;
/// 内容View
@property (strong, nonatomic) UIView *contentView;
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
/// 提示Label
@property (strong, nonatomic) UILabel *subTitleLabel;
/// 密码输入框
@property (strong, nonatomic) UITextField *passwordTextField;
/// 提示Label
@property (strong, nonatomic) UILabel *tipLabel;
/// 确定按钮
@property (strong, nonatomic) UIButton *sureButton;
/// 密码是否成功回调
@property (copy, nonatomic) PasswordRightBlock isSuccessBlock;
/**
 Modal显示选择商品数目弹窗
 
 @param superVc 父控制器
 @param isRight 密码是否正确
 @return 组件实例对象
 */
+ (instancetype)showWithSuperVc:(UIViewController *)superVc
                        isRight:(PasswordRightBlock)isRight;


+ (instancetype)showWithIsRight:(PasswordRightBlock)isRight;

@end
