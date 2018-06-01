//
//  TCUploadFansController.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/9.
//  Copyright © 2018年 wsl. All rights reserved.
//  上传粉丝控制器

#import "TCUploadFansController.h"
#import "TalkChainHeader.h"
#import "TCUploadFansView.h"
#import "AppDelegate.h"
#import "SyncFansUtil.h"
#import "AuthorizationUtil.h"
#import "AppDelegate.h"

@interface TCUploadFansController ()

@property (strong, nonatomic) TCUploadFansView *rootView;

@end

@implementation TCUploadFansController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"导入粉丝";

    if (self.type == UploadFansTypeRegister) {
        [EnvironmentVariable setProperty:@(LoginStepNoFans) forKey:LOGIN_STEP];
    }

    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud" fromDictName:@"wallet"];
    [self rootView];
    [SyncFansUtil requestAuthorizationAddressBook];

    if (self.type == UploadFansTypeRegister) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStyleDone target:self action:@selector(skipAciton)];
    }

}

#pragma mark - 下一步
- (void)nextAction{
    WEAK(self)
    [self showTCHUDWithTitle:@"正在读取通讯录好友"];
    [SyncFansUtil syncFansWithNoAuthor:^{
        [weakself hiddenTCHUD];
        [AuthorizationUtil showDeniedAlertWithType:AuthorizationTypeAddressBook];
    } success:^(id result) {
        [weakself hiddenTCHUD];
        [weakself uploadFansIsSuccess:YES];
    } fail:^(NSString *errorDescription) {
        [weakself hiddenTCHUD];
        [weakself uploadFansIsSuccess:NO];
    }];
}

#pragma mark - 加载登录信息
- (void)uploadFansIsSuccess:(BOOL)isUploadFanSuccess{
    if (isUploadFanSuccess) {
        [EnvironmentVariable setProperty:@(LoginStepLoginSuccess) forKey:LOGIN_STEP];
        if (self.type == UploadFansTypeRegister) {
            [(AppDelegate *)APPDELEGATE goMainView];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        WEAK(self)
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"读取通讯录好友失败" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself nextAction];
        }]];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - 返回
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 跳过
- (void)skipAciton{
    [EnvironmentVariable setProperty:@(LoginStepLoginSuccess) forKey:LOGIN_STEP];
    [(AppDelegate *)APPDELEGATE goMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyload
- (TCUploadFansView *)rootView{
    if (!_rootView) {
        _rootView = [TCUploadFansView new];
        [_rootView.nextButton setTitle:@"导入" forState:UIControlStateNormal];
        [_rootView.subTitleLabel removeFromSuperview];
        [_rootView.tipLabel setText:@"导入您的手机通讯录，将把通讯录中的联系人自动设置为您的粉丝" lineSpacing:2];
        _rootView.subTipView.tipLabel.text = @"点击导入粉丝，将获得银钻奖励";
        _rootView.subTitleImageView.image = [UIImage theme_bundleImageNamed:@"login/wallet/wallet_importFans_top.png"]();
        _rootView.subTipView.rewardLabel.text = @"10000";
        [_rootView.nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:_rootView];
        [_rootView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view);
            }
        }];
    }
    return _rootView;
}

@end

