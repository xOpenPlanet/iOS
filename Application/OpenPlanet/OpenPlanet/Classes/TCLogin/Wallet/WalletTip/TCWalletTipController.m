//
//  TCImportWalletController.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/12.
//  Copyright © 2018年 wsl. All rights reserved.
//  导入钱包控制器

#import "TCWalletTipController.h"
#import "TalkChainHeader.h"
#import "TCWalletTipView.h"
#import "TCInputMemoryWordController.h"
#import <ethers/Account.h>
#import "TCBackUpMemoryWordController.h"

@interface TCWalletTipController ()

@property (strong, nonatomic) TCWalletTipView *rootView;

@end

@implementation TCWalletTipController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.type == WalletTypeLoginBackUp?@"恢复基地账户":@"创建基地账户";
    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud" fromDictName:@"wallet"];
    [self rootView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 返回
- (void)backAction{
    if (self.type == WalletTypeRegister) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 创建钱包
- (void)createWalletAction{
    if (self.type == WalletTypeLoginBackUp) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"该账号已创建基地，创建新基地旧基地和能量币将作废，是否继续创建基地？" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self createWallet];
        }]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else{
        [self createWallet];
    }
}

#pragma mark - 创建钱包
- (void)createWallet{
    /// 创建钱包
    Account *account = [Account randomMnemonicAccount];
    TCBackUpMemoryWordController *nextVc = [TCBackUpMemoryWordController new];
    nextVc.phone = self.phone;
    nextVc.password = self.password;
    nextVc.type = self.type;
    nextVc.account = account;
    [self.navigationController pushViewController:nextVc animated:YES];
}

#pragma mark - 导入钱包
- (void)importWalletAction{
    // 导入钱包
    TCInputMemoryWordController *nextVc = [TCInputMemoryWordController new];
    nextVc.phone = self.phone;
    nextVc.password = self.password;
    nextVc.type = self.type;
    [self.navigationController pushViewController:nextVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyload
- (TCWalletTipView *)rootView{
    if (!_rootView) {
        _rootView = [TCWalletTipView new];
        
        if (self.type == WalletTypeLoginBackUp) {
            _rootView.subTitleImageView.image = [UIImage theme_bundleImageNamed:@"login/wallet/wallet_importWallet_top.png"]();
            _rootView.subTitleLabel.text = @"恢复您的基地账户";
            [_rootView.tipLabel setText:@"请填写您的基地账户”助记词“，没有他们您的账户将没法恢复，务必妥善保管好您的助记词" lineSpacing:2];
            _rootView.subTipView.tipLabel.text = @"填写助记词请留意周边环境";
        }else{
            _rootView.subTitleImageView.image = [UIImage theme_bundleImageNamed:@"login/wallet/wallet_backup_top.png"]();
            _rootView.subTitleLabel.text = @"创建您的基地账户";
            [_rootView.tipLabel setText:@"基地账户是您在区块链上的唯一地址，它根据您的私钥生成，请在创建完基地账户后，做好私钥和基地账户的备份" lineSpacing:2];
            _rootView.subTipView.tipLabel.text = @"请保留创建过程中生成的信息";
        }
        
        [_rootView.nextButton setTitle:@"创建基地账户" forState:UIControlStateNormal];
        [_rootView.importWalletButton setTitle:@"恢复基地账户" forState:UIControlStateNormal];
        [_rootView.nextButton addTarget:self action:@selector(createWalletAction) forControlEvents:UIControlEventTouchUpInside];
        [_rootView.importWalletButton addTarget:self action:@selector(importWalletAction) forControlEvents:UIControlEventTouchUpInside];
        
        
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
