//
//  TCUploadAvatarController.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/12.
//  Copyright © 2018年 wsl. All rights reserved.
//  设置头像控制器

#import "TCUploadAvatarController.h"
#import "TalkChainHeader.h"
#import "TCUploadAvatarView.h"
#import "TCUploadFansController.h"
#import "EnvironmentVariable.h"
#import "PansoftUpDwonload.h"
#import "EFChatHttpManager.h"
#import "JFMessageManager.h"
#import "MessageDataManager.h"
#import "AuthorizationUtil.h"
#import "AppDelegate.h"

@interface TCUploadAvatarController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) TCUploadAvatarView *rootView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@end

@implementation TCUploadAvatarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置头像";

    [EnvironmentVariable setProperty:@(LoginStepNoAvatar) forKey:LOGIN_STEP];
    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud" fromDictName:@"wallet"];
    [self rootView];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStyleDone target:self action:@selector(skipAciton)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 下一步
- (void)nextAction{
    [self showTCHUDWithTitle:@"正在上传头像"];
    NSString *avatarId = [EnvironmentVariable getIMUserID];
    NSString *currentDateStr = [NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970] * 1000];
    NSString *name = [NSString stringWithFormat:@"/%@.png", currentDateStr];
    WEAK(self)
    UIImage *avatarImage = self.rootView.avatarButton.imageView.image;
    NSData *data = UIImageJPEGRepresentation(avatarImage, 0.1);
    PansoftUpDwonload *pansoftUpdownLoad = [[PansoftUpDwonload alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [pansoftUpdownLoad uploadDatasToPansoftFileUploadfileDatas:data fileName:name IMStructMessage:nil block:^(NSString *url, NSError *error) {
            if (!error) {
                //后台更换头像
               NSString *headImageURL = [NSString stringWithString:url];
                NSString *userid = [EnvironmentVariable getIMUserID];
                NSString *password = [EnvironmentVariable getIMPassword];
                EFChatHttpManager *httpManager = [[EFChatHttpManager alloc] init];
                [httpManager HttpRequestForChangeHeadImageWithUserId:userid userPassword:password headImageURL:url success:^(id responseObject) {
                    [weakself hiddenTCHUD];
                    //本地数据库更换头像
                    MessageDbManager *dbManager = [[JFMessageManager sharedMessageManager] messageDBManager];
                    [dbManager updateUserWithUserId:[userid integerValue] avatar:url];
                    [EnvironmentVariable setProperty:url forKey:@"avatar"];
                    // 去上传粉丝界面
                    [weakself skipAciton];

                } failure:^(NSString *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakself hiddenTCHUD];
                        [weakself showSystemAlertWithTitle:@"提示" message:@"上传头像失败"];
                    });
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself hiddenTCHUD];
                    [weakself showSystemAlertWithTitle:@"提示" message:@"上传头像失败"];
                });
            }
        }];
    });
}

#pragma mark - 头像点击事件
- (void)avaterButtonAction{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片来源" preferredStyle:UIAlertControllerStyleActionSheet];

    WEAK(self)
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [alertVc addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [AuthorizationUtil autoAuthorizationWithType:AuthorizationTypePhotoLibrary complete:^(BOOL granted) {
                    if (granted) {
                        weakself.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        [weakself presentViewController:weakself.imagePicker animated:YES completion:^{
                            if (@available(iOS 11.0, *)) {
                                [APPLICATION setStatusBarHidden:YES];
                            }
                        }];
                    }

                }];
            });
        }]];

    }

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [alertVc addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [AuthorizationUtil autoAuthorizationWithType:AuthorizationTypeCamera complete:^(BOOL granted) {
                    if (granted) {
                        weakself.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        [weakself presentViewController:weakself.imagePicker animated:YES completion:^{
                            if (@available(iOS 11.0, *)) {
                                [APPLICATION setStatusBarHidden:YES];
                            }
                        }];
                    }
                }];
            });
        }]];
    }

    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    /// 1.设置显示新头像
    [self.rootView.avatarButton setImage:image forState:UIControlStateNormal];

    WEAK(self)
    [self dismissViewControllerAnimated:YES completion:^{
        if (APPLICATION.statusBarHidden) {
            [APPLICATION setStatusBarHidden:NO];
        }
        APPLICATION.statusBarStyle = UIStatusBarStyleLightContent;
        [weakself nextButtonIsEnable:YES];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePicker dismissViewControllerAnimated:YES completion:^{
        if (APPLICATION.statusBarHidden) {
            [APPLICATION setStatusBarHidden:NO];
        }
        APPLICATION.statusBarStyle = UIStatusBarStyleLightContent;
    }];
}

#pragma mark - 跳过
- (void)skipAciton{
    TCUploadFansController * importFansVc = [TCUploadFansController new];
    importFansVc.type = UploadFansTypeRegister;
    [self.navigationController pushViewController:importFansVc animated:YES];
}

#pragma mark - 下一步按钮是否可用
- (void)nextButtonIsEnable:(BOOL)isEnable{
    self.rootView.nextButton.enabled = isEnable;
    self.rootView.nextButton.alpha = isEnable?1:0.4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyload
- (TCUploadAvatarView *)rootView{
    if (!_rootView) {
        _rootView = [TCUploadAvatarView new];
        [_rootView.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        _rootView.subTitleLabel.text = [EnvironmentVariable getPropertyForKey:@"nickName" WithDefaultValue:@"昵称"];
        _rootView.tipLabel.text = @"设置一张您的图片作为您的头像";
        _rootView.subTipView.tipLabel.text = @"设置好用户头像,将获得银钻奖励";
        _rootView.subTipView.rewardLabel.text = @"5000";
        [_rootView.nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        [_rootView.avatarButton addTarget:self action:@selector(avaterButtonAction) forControlEvents:UIControlEventAllEvents];
        [self nextButtonIsEnable:NO];

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

- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        _imagePicker.navigationBar.translucent = NO;

    }
    return _imagePicker;
}

@end
