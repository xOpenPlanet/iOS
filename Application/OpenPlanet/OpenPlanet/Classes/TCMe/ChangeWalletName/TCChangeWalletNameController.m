//
//  TCChangeNameController.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/27.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "TCChangeWalletNameController.h"

@interface TCChangeWalletNameController ()
/// 灰色透明蒙版
@property (strong, nonatomic) UIView *maskView;
/// 内容View
@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UIButton *sureButton;

@property (copy, nonatomic) StringBlock nameBlock;

@end

@implementation TCChangeWalletNameController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleLabel.text = @"修改账户名称";
    self.nameTextField.placeholder = @"请输入账户名称";
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];

    /// 添加键盘弹出关闭通知
    WEAK(self)
    [NOTIFICATIONCENTER addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSDictionary *userInfo = note.userInfo;
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = aValue.CGRectValue;

        [weakself keyBoardIsShow:YES bottom:50 + keyboardRect.size.height];
    }];
    [NOTIFICATIONCENTER addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakself keyBoardIsShow:NO bottom:50];
    }];
}

#pragma mark - 键盘出现关闭方法
- (void)keyBoardIsShow:(BOOL)isShow bottom:(CGFloat)bottom{


    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-bottom);
        } else {
            make.bottom.equalTo(self.view).offset(-bottom);
        }
    }];


    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 动画显示modal视图
+ (instancetype)showWithSuperVc:(UIViewController *)superVc oldName:(NSString *)oldName name:(StringBlock)nameBlock{
    TCChangeWalletNameController * modalVc = [TCChangeWalletNameController new];

    if (modalVc.nameBlock != nameBlock) {
        modalVc.nameBlock = nameBlock;
    }


    modalVc.modalPresentationStyle =  UIModalPresentationOverFullScreen;
    /// 自定义弹出动画(将animated设置成NO)
    [superVc presentViewController:modalVc animated:NO completion:^{
        modalVc.nameTextField.text = oldName;
    }];
    return modalVc;
}



#pragma mark - 当控制器View加载完成的时候，弹出内容View
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.nameTextField becomeFirstResponder];
    WEAK(self)
    [UIView animateWithDuration:0.25 animations:^{
        weakself.maskView.alpha = 0.5;
        [weakself.view layoutIfNeeded];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    self.maskView.alpha = 0;
}

#pragma mark - 确认按钮事件
- (void)sureButtonAction{
    if (self.nameBlock) {
        self.nameBlock(self.nameTextField.text);
    }
    [self dismissViewController];
}

#pragma mark - 关闭modal视图
- (void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyload
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.backgroundColor = cBlackColor;
        _maskView.alpha = 0;
        [self.view addSubview:_maskView];
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];
        [_maskView ex_addTapGestureWithTarget:self action:@selector(dismissViewController)];
    }
    return _maskView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView  = [UIView new];
        _contentView.backgroundColor = cWhiteColor;
        _contentView.layer.cornerRadius = 20;
        _contentView.layer.masksToBounds = YES;
        [self.view insertSubview:_contentView aboveSubview:self.maskView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-50);
            } else {
                make.bottom.equalTo(self.view).offset(-50);
            }
            make.left.right.equalTo(self.view).inset(30);
        }];
    }
    return _contentView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = BOLD_FONT(17);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(20);
            make.top.equalTo(self.contentView).offset(20);
        }];
    }
    return _titleLabel;
}

- (UITextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [UITextField new];
        _nameTextField.borderStyle = UITextBorderStyleNone;
        _nameTextField.font = FONT(15);
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:_nameTextField];
        [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.left.right.equalTo(self.contentView).inset(20);
            make.height.equalTo(@45);
        }];

        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = cGroupTableViewBackgroundColor;
        [_nameTextField addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_nameTextField).inset(-3);
            make.bottom.equalTo(_nameTextField);
            make.height.equalTo(@1);
        }];
    }
    return _nameTextField;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _sureButton.backgroundColor = TCThemeColor;
        _sureButton.tintColor = cWhiteColor;
        _sureButton.layer.cornerRadius = 22.5;
        [_sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sureButton];
        [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.nameTextField.mas_bottom).offset(25);
            make.height.equalTo(@45);
            make.bottom.equalTo(self.contentView).inset(20);
        }];
    }
    return _sureButton;
}

@end
