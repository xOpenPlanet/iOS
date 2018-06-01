//
//  TCInputMemoryWordController.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/14.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCInputMemoryWordController.h"
#import "TCUploadAvatarController.h"
#import "TCUploadFansController.h"
#import <ethers/WalletManager.h>
#import <ethers/Wallet.h>
#import "WalletUtil.h"
#import <ethers/SecureData.h>
#import "TCMemoryRecoverWalletView.h"
#import "TCPriviteKeyRecoverWalletView.h"
#import "SLTitleView.h"
#import "SLPageContentView.h"
#import "YYRSACrypto.h"
#import "AppDelegate.h"

@interface TCInputMemoryWordController ()<UITextFieldDelegate,UITextViewDelegate>

/// 分页标题数据源
@property (strong, nonatomic) NSArray *titles;
/// 标题组件
@property (strong, nonatomic) SLTitleView *pageTitleView;
/// 内容
@property (strong, nonatomic) SLPageContentView *pageContentView;
/// 助记词界面
@property (strong, nonatomic) TCMemoryRecoverWalletView *memoryView;
/// 私钥界面
@property (strong, nonatomic) TCPriviteKeyRecoverWalletView *priviteKeyView;

@end

@implementation TCInputMemoryWordController {
    Account *account;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"恢复基地";
    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud" fromDictName:@"wallet"];
    [self setupForDismissKeyboard];
    [self.pageTitleView scrollToTitleWithIndex:0];
    [self.pageContentView setCurrentIndex:0];
    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(walletAccountAdded) name:WalletAccountAddedNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSUInteger idx = 0;
    for (int i = 0; i < self.memoryView.memoryWordView.subviews.count; i ++ ) {
        UITextField *currentTextField = self.memoryView.memoryWordView.subviews[i];
        if ([textField isEqual:currentTextField]) {
            idx = i;
        }
    }
    
    if (idx == self.memoryView.memoryWordView.subviews.count - 1) {
        /// 最后一个结束编辑
        [self.view endEditing:YES];
    }else{
        for (int i = 0; i < self.memoryView.memoryWordView.subviews.count; i ++ ) {
            UITextField *currentTextField = self.memoryView.memoryWordView.subviews[i];
            if (i == idx + 1) {
                [currentTextField becomeFirstResponder];
            }
        }
    }
    
    return YES;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    BOOL isTextFieldEmpty = (textView.text.length > 0);
    self.priviteKeyView.nextButton.enabled = isTextFieldEmpty;
    self.priviteKeyView.nextButton.alpha= isTextFieldEmpty?1:0.4;
    
}

- (void)memoryViewTextChanged{
    BOOL isTextFieldEmpty = YES;
    for (UITextField *textField in self.memoryView.memoryWordView.subviews) {
        if (textField.text.length == 0) {
            isTextFieldEmpty = YES;
            self.memoryView.nextButton.enabled = !isTextFieldEmpty;
            self.memoryView.nextButton.alpha= isTextFieldEmpty?0.4:1;
            return;
        }
        isTextFieldEmpty = NO;
    }
    self.memoryView.nextButton.enabled = !isTextFieldEmpty;
    self.memoryView.nextButton.alpha= isTextFieldEmpty?0.4:1;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

#pragma mark - 助记词恢复事件
- (void)memoryRecoverAction{
    /// 助记词字符串
    NSMutableString *memoryWord = [NSMutableString string];
    for (UITextField *textField in self.memoryView.memoryWordView.subviews) {
        [memoryWord appendString:textField.text];
        [memoryWord appendString:@" "];
    }
    memoryWord = [memoryWord substringToIndex:memoryWord.length - 1];
    
    if ([Account isValidMnemonicPhrase:memoryWord]) {
        account = [Account accountWithMnemonicPhrase:memoryWord];
        [self isAddWallet:account];
    }else {
        [self showSystemAlertWithTitle:@"提示" message:@"恢复失败，请检查助记词"];
    }
}

#pragma mark - 私钥恢复
- (void)priviteKeyRecoverAction{
    NSString *priviteKey = self.priviteKeyView.priviteKeyTextView.text;
    if (![priviteKey hasPrefix:@"0x"]) {
        priviteKey = [@"0x" stringByAppendingString:priviteKey];
    }
    NSData *data = (NSData *)[SecureData secureDataWithHexString:priviteKey];
    account = [Account accountWithPrivateKey:data];
    if (account) {
        [self isAddWallet:account];
    }else{
        [self showSystemAlertWithTitle:@"提示" message:@"恢复失败，请检查秘钥"];
    }
}


#pragma mark - 比对服务器钱包地址，是否添加钱包
- (void)isAddWallet:(Account *)account{
    if (self.type == WalletTypeLoginBackUp) {
        NSString *userWalletAddress = [EnvironmentVariable getPropertyForKey:@"loginWalletAddress" WithDefaultValue:@""];
        // 地址不包含0x添加0x在进行比较
        if (![userWalletAddress hasPrefix:@"0x"]) {
            userWalletAddress = [@"0x" stringByAppendingString:userWalletAddress];
        }
        
        if ([[userWalletAddress uppercaseString] isEqualToString:[[account.address checksumAddress]uppercaseString]]) {
            [self addWalletToAccount:account];
        }else{
            [self showSystemAlertWithTitle:@"提示" message:@"恢复失败，只能恢复该账号绑定的基地"];
        }
    }else{
        [self addWalletToAccount:account];
    }
}

- (void)addWalletToAccount:(Account *)account{
    [self showTCHUDWithTitle:@"恢复基地账户中..."];
    Wallet* wallet = [WalletManager sharedWallet];
    [wallet addAccount:account password:self.password nickname:[EnvironmentVariable getWalletUserID]];
    [EnvironmentVariable setWalletUserID:[EnvironmentVariable getWalletUserID] password:self.password];
    [EnvironmentVariable setWalletUserID:[EnvironmentVariable getWalletUserID] address:[account.address checksumAddress]];
}



#pragma mark - 钱包新增回调
-(void)walletAccountAdded {
    [WalletManager refreshWallet];
    // 钱包地址
    NSString *address = [account.address checksumAddress];
    // 钱包公钥
    NSString *publicKey = [account publicKey];
    // 创建通讯公钥
    WEAK(self)
    [YYRSACrypto rsa_generate_key:^(MIHKeyPair *keyPair, bool isExist) {
        NSString *comPublicKey = [YYRSACrypto getPublicKey:keyPair];
        NSString *comPrivateKey = [YYRSACrypto getPrivateKey:keyPair];
        // ENV存储通讯公钥和私钥
        [WalletUtil saveComPublicKey:comPublicKey comPrivateKey:comPrivateKey];
        
        [TCLoginManager saveWalletWithWalletAddress:address publicKey:publicKey comPublicKey:comPublicKey success:^(id result) {
            [weakself hiddenTCHUD];
            if ([[result valueForKey:@"result"] isEqualToString:@"success"]) {
                switch (self.type) {
                    case WalletTypeRegister:{
                        [EnvironmentVariable setProperty:@(LoginStepNoAvatar) forKey:LOGIN_STEP];
                    }
                        break;
                    case WalletTypeLogin:
                    case WalletTypeLoginBackUp:{
                        [EnvironmentVariable setProperty:@(LoginStepNoFans) forKey:LOGIN_STEP];
                    }
                        break;
                    case WalletTypeAdd:
                        break;
                    default:
                        break;
                }
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"恢复成功" preferredStyle:UIAlertControllerStyleAlert];
                [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakself goNextController];
                }]];
                [weakself presentViewController:alertVc animated:YES completion:nil];
            }else{
                [weakself showSystemAlertWithTitle:@"提示" message:@"保存失败"];
            }
        } fail:^(NSString *errorDescription) {
            [weakself hiddenTCHUD];
            [weakself showSystemAlertWithTitle:@"提示" message:@"保存失败"];
        }];
        
    }archiverFileName:nil];
    
}

- (void)goNextController{
    switch (self.type) {
        case WalletTypeRegister:{
            TCUploadAvatarController * setAvatarVc = [TCUploadAvatarController new];
            [self.navigationController pushViewController:setAvatarVc animated:YES];
        }
            break;
        case WalletTypeLogin:
        case WalletTypeLoginBackUp:{
            TCUploadFansController *importFansVc = [TCUploadFansController new];
            importFansVc.type = UploadFansTypeRegister;
            [self.navigationController pushViewController:importFansVc animated:YES];
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


- (NSArray *)getChildVc{
    SLPageEntity *entity1 = [SLPageEntity new];
    entity1.title = @"助记词";
    entity1.childView = self.memoryView;
    
    SLPageEntity *entity2 = [SLPageEntity new];
    entity2.title = @"私钥";
    entity2.childView = self.priviteKeyView;
    
    self.titles = @[entity1,entity2];
    return self.titles;
}

#pragma mark - lazyload
- (SLTitleView *)pageTitleView{
    if (!_pageTitleView) {
        NSMutableArray *titles = [NSMutableArray array];
        NSArray *pageEntitys = [self getChildVc];
        for (SLPageEntity *entity in pageEntitys) {
            [titles addObject:entity.title];
        }
        WEAK(self)
        /// 初始化标题栏
        _pageTitleView = [SLTitleView viewWithTitles:titles  titleBtnSelect:^(NSInteger idx) {
            [weakself.pageContentView setCurrentIndex:idx];
        } TitleNormalColor:cDarkGrayColor titleSelectColor:TCStrongThemeColor lineColor:TCStrongThemeColor titleType:SLPageViewTitleTypeNone];
        
        [self.view addSubview:_pageTitleView];
        [_pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
        }];
    }
    return _pageTitleView;
}

- (SLPageContentView *)pageContentView{
    if (!_pageContentView) {
        NSMutableArray *views = [NSMutableArray array];
        NSArray *pageEntitys = [self getChildVc];
        for (SLPageEntity *entity in pageEntitys) {
            [views addObject:entity.childView];
        }
        _pageContentView = [SLPageContentView pageContentViewWithChildViews:views];
        [self.view addSubview:_pageContentView];
        
        [_pageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pageTitleView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        WEAK(self)
        _pageContentView.pageScroll = ^(NSInteger idx, CGFloat progress) {
            [weakself.pageTitleView scrollToTitleWithIndex:idx];
        };
    }
    return _pageContentView;
}


- (TCMemoryRecoverWalletView *)memoryView{
    if (!_memoryView) {
        _memoryView = [TCMemoryRecoverWalletView new];
        NSString *nextTitle = self.type == WalletTypeAdd?@"完成":@"下一步";
        [_memoryView.nextButton setTitle:nextTitle forState:UIControlStateNormal];
        [_memoryView.tipLabel setText:@"通过助记词恢复您的基地账户" lineSpacing:2];
        [_memoryView.nextButton addTarget:self action:@selector(memoryRecoverAction) forControlEvents:UIControlEventTouchUpInside];
        for (UITextField *textField in _memoryView.memoryWordView.subviews) {
            textField.delegate = self;
            [textField addTarget:self action:@selector(memoryViewTextChanged) forControlEvents:UIControlEventEditingChanged];
        }
        [self memoryViewTextChanged];
    }
    return _memoryView;
}

- (TCPriviteKeyRecoverWalletView *)priviteKeyView{
    if (!_priviteKeyView) {
        _priviteKeyView = [TCPriviteKeyRecoverWalletView new];
        NSString *nextTitle = self.type == WalletTypeAdd?@"完成":@"下一步";
        [_priviteKeyView.nextButton setTitle:nextTitle forState:UIControlStateNormal];
        [_priviteKeyView.tipLabel setText:@"通过私钥恢复您的基地账户" lineSpacing:2];
        [_priviteKeyView.nextButton addTarget:self action:@selector(priviteKeyRecoverAction) forControlEvents:UIControlEventTouchUpInside];
        _priviteKeyView.priviteKeyTextView.delegate = self;
        [self textViewDidChange:_priviteKeyView.priviteKeyTextView];
    }
    return _priviteKeyView;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WalletAccountAddedNotification object:nil];
}

@end
