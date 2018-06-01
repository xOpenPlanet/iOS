//
//  TCSureMemoryWordController.m
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/26.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCSureMemoryWordController.h"
#import "TCSureMemoryView.h"
#import "TCUploadAvatarController.h"
#import "TCUploadFansController.h"
#import "WalletUtil.h"
#import <ethers/Account.h>
#import <ethers/CloudKeychainSigner.h>
#import <ethers/Wallet.h>
#import <ethers/WalletManager.h>
#import "YYRSACrypto.h"
#import "UIViewController+TCHUD.h"
#import "AppDelegate.h"

@interface TCSureMemoryWordController ()
@property (strong, nonatomic) TCSureMemoryView *rootView;
@property (strong, nonatomic) NSMutableArray *noSelectMemoryWords;
@property (strong, nonatomic) NSMutableArray *selectedMemoryWords;

@end

@implementation TCSureMemoryWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认您的基地助记词";
    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud" fromDictName:@"wallet"];
    [self rootView];

    [NOTIFICATIONCENTER addObserver:self selector:@selector(walletAccountAdded) name:WalletAccountAddedNotification object:nil];

    self.noSelectMemoryWords = [NSMutableArray arrayWithArray:self.memoryWord];
    [self refreshMemoryWordView];
}

#pragma mark - 返回
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 下一步
- (void)nextAction{
    NSString *oldMemoryWord = [self.memoryWord componentsJoinedByString:@" "];
    NSString *newMemoryWord = [self.selectedMemoryWords componentsJoinedByString:@" "];
    if ([newMemoryWord isEqualToString:oldMemoryWord]) {
        [self showTCHUDWithTitle:@"正在备份基地"];
        Wallet *wallet = [WalletManager sharedWallet];
        [wallet addAccount:self.account password:self.password nickname:[EnvironmentVariable getWalletUserID]];
        [EnvironmentVariable setWalletUserID:[EnvironmentVariable getWalletUserID] password:self.password];
        [EnvironmentVariable setWalletUserID:[EnvironmentVariable getWalletUserID] address:[self.account.address checksumAddress]];
    }else{
        [self showSystemAlertWithTitle:@"提示" message:@"备份失败，请检查您的助记词"];
    }
}


#pragma mark - 钱包增加回调
-(void)walletAccountAdded {
    [WalletManager refreshWallet];
    // 钱包地址
    NSString *address = [self.account.address checksumAddress];
    // 钱包公钥
    NSString *publicKey = [self.account publicKey];
    // 创建通讯公钥
    WEAK(self)
    [YYRSACrypto rsa_generate_key:^(MIHKeyPair *keyPair, bool isExist) {
        NSString *comPublicKey = [YYRSACrypto getPublicKey:keyPair];
        NSString *comPrivateKey = [YYRSACrypto getPrivateKey:keyPair];
        // ENV存储通讯公钥和私钥
        [WalletUtil saveComPublicKey:comPublicKey comPrivateKey:comPrivateKey];

        [TCLoginManager saveWalletWithWalletAddress:address publicKey:publicKey comPublicKey:comPublicKey success:^(id result) {
            [weakself hiddenTCHUD];
            [EnvironmentVariable setProperty:@(LoginStepNoAvatar) forKey:LOGIN_STEP];
            if ([[result valueForKey:@"result"] isEqualToString:@"success"]) {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"基地账户添加成功" preferredStyle:UIAlertControllerStyleAlert];
                [alertVc addAction:[UIAlertAction actionWithTitle:self.type == WalletTypeAdd?@"完成":@"下一步" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakself goNextController];
                }]];
                [weakself presentViewController:alertVc animated:YES completion:nil];
            }else{
                [weakself hiddenTCHUD];
                [weakself showSystemAlertWithTitle:@"提示" message:@"保存基地账户失败,请重试"];
            }
        } fail:^(NSString *errorDescription) {
            [weakself hiddenTCHUD];
            [weakself showSystemAlertWithTitle:@"提示" message:@"保存基地账户失败，请重试"];
        }];


    } archiverFileName:nil];




}


#pragma mark - 去下一个界面
- (void)goNextController{
    switch (self.type) {
        case WalletTypeRegister:{
            TCUploadAvatarController *vc = [TCUploadAvatarController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case WalletTypeLogin:
        case WalletTypeLoginBackUp:{
            TCUploadFansController *vc = [TCUploadFansController new];
            vc.type = UploadFansTypeRegister;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case WalletTypeAdd:{
            [NOTIFICATIONCENTER postNotificationName:@"refreshWalletAccountList" object:nil];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
            break;

        default:
            break;
    }
}

- (void)noSelectWordTapAciton:(NSString *)word index:(NSUInteger)index{
    [self.noSelectMemoryWords removeObjectAtIndex:index];
    [self.selectedMemoryWords addObject:word];
    [self refreshMemoryWordView];
}

- (void)selectedWordTapAciton:(NSString *)word index:(NSUInteger)index{
    [self.selectedMemoryWords removeObjectAtIndex:index];
    [self.noSelectMemoryWords addObject:word];
    [self refreshMemoryWordView];
}

- (void)refreshMemoryWordView{
    self.noSelectMemoryWords = [self.noSelectMemoryWords sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }].mutableCopy;

    self.rootView.noSelectMemoryWords = self.noSelectMemoryWords;
    self.rootView.selectedMemoryWords = self.selectedMemoryWords;

    if (self.selectedMemoryWords.count == 12) {
        self.rootView.nextButton.enabled = YES;
        self.rootView.nextButton.alpha = 1;
    }else{
        self.rootView.nextButton.enabled = NO;
        self.rootView.nextButton.alpha = 0.4;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyload
- (TCSureMemoryView *)rootView{
    if (!_rootView) {
        _rootView = [TCSureMemoryView new];
        [_rootView.nextButton setTitle:@"确认" forState:UIControlStateNormal];
        _rootView.subTitleLabel.text = @"确认您的基地助记词";
        [_rootView.tipLabel setText:@"请按顺序点击助记词，以确认您的助记词正确" lineSpacing:2];
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


        WEAK(self);
        _rootView.noSelectMemoryWordTapAction = ^(NSString *word, NSUInteger index) {
            [weakself noSelectWordTapAciton:word index:index];
        };
        _rootView.selectedMemoryWordTapAction = ^(NSString *word, NSUInteger index) {
            [weakself selectedWordTapAciton:word index:index];
        };

    }
    return _rootView;
}

- (NSMutableArray *)noSelectMemoryWords{
    if (!_noSelectMemoryWords) {
        _noSelectMemoryWords = [NSMutableArray array];
    }
    return _noSelectMemoryWords;
}

- (NSMutableArray *)selectedMemoryWords{
    if (!_selectedMemoryWords) {
        _selectedMemoryWords = [NSMutableArray array];
    }
    return _selectedMemoryWords;
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WalletAccountAddedNotification object:nil];
}
@end
