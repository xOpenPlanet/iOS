//
//  TCPriviteKeyController.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/27.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "TCBackUpPriviteKeyController.h"
#import "TalkChainHeader.h"
#import "EdgeInsetLabel.h"

@interface TCBackUpPriviteKeyController ()

/// 灰色透明蒙版
@property (strong, nonatomic) UIView *maskView;
/// 内容View
@property (strong, nonatomic) UIView *contentView;
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
/// 关闭按钮
@property (strong, nonatomic) UIButton *closeButton;
/// 提示label
@property (strong, nonatomic) UILabel *tipLabel;
/// 私钥
@property (strong, nonatomic) EdgeInsetLabel *priviteKeyLabel;
/// 确定按钮
@property (strong, nonatomic) UIButton *sureButton;

@end

@implementation TCBackUpPriviteKeyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"备份私钥";
    [self.sureButton setTitle:@"复制" forState:UIControlStateNormal];
    self.tipLabel.text = @"安全警告：私钥未经加密，导出存在风险，建议使用助记词进行备份";
    [self closeButton];
}

#pragma mark - 动画显示modal视图
+ (instancetype)showWithSuperVc:(UIViewController *)superVc priviteKey:(NSString *)priviteKey{
    TCBackUpPriviteKeyController * modalVc = [TCBackUpPriviteKeyController new];

    modalVc.modalPresentationStyle =  UIModalPresentationOverFullScreen;
    /// 自定义弹出动画(将animated设置成NO)
    [superVc presentViewController:modalVc animated:NO completion:^{
        modalVc.priviteKeyLabel.text = priviteKey;
    }];
    return modalVc;
}



#pragma mark - 当控制器View加载完成的时候，弹出内容View
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
    [UIPasteboard generalPasteboard].string = SafeString(self.priviteKeyLabel.text);
    [self.view jk_makeToast:@"私钥已复制" duration:0.8f position:JKToastPositionCenter];
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
    }
    return _maskView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView  = [UIView new];
        _contentView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];
        _contentView.layer.cornerRadius = 20;
        _contentView.layer.masksToBounds = YES;
        [self.view insertSubview:_contentView aboveSubview:self.maskView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(100);
            } else {
                make.top.equalTo(self.view).offset(100);
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
        _titleLabel.theme_textColor  = [UIColor theme_colorPickerForKey:@"cellTitle"];
        _titleLabel.font = BOLD_FONT(17);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(20);
        }];
    }
    return _titleLabel;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage *closeImage = [UIImage theme_bundleImageNamed:@"me/me_backUpPriviteKey_close@3x.png"]();
        [_closeButton setImage:closeImage forState:UIControlStateNormal];
        _closeButton.tintColor = cWhiteColor;
        [self.contentView addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).inset(20);
        }];
        [_closeButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = FONT(13);
        _tipLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"tipColor" fromDictName:@"opMe"];
        _tipLabel.numberOfLines = 0;
        [self.contentView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
            make.left.right.inset(20);
        }];
    }
    return _tipLabel;
}

- (EdgeInsetLabel *)priviteKeyLabel{
    if (!_priviteKeyLabel) {
        _priviteKeyLabel = [EdgeInsetLabel new];
        _priviteKeyLabel.font = FONT(13);
        _priviteKeyLabel.numberOfLines = 0;
        _priviteKeyLabel.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
        _priviteKeyLabel.theme_textColor  = [UIColor theme_colorPickerForKey:@"cellTitle"];
        _priviteKeyLabel.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [self.contentView addSubview:_priviteKeyLabel];
        [_priviteKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(20);
            make.top.equalTo(self.tipLabel.mas_bottom).offset(20);
        }];
    }
    return _priviteKeyLabel;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _sureButton.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"nextButtonBgColor" fromDictName:@"login"];
        _sureButton.theme_tintColor  = [UIColor theme_colorPickerForKey:@"nextButtonTintColor" fromDictName:@"login"];
        _sureButton.layer.cornerRadius = 22.5;
        [_sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sureButton];
        [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(20);
            make.top.equalTo(self.priviteKeyLabel.mas_bottom).offset(25);
            make.height.equalTo(@45);
            make.bottom.equalTo(self.contentView).inset(20);
        }];
    }
    return _sureButton;
}

@end
