//
//  TCOutMiController.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/31.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "TCOutMiController.h"
#import "TalkChainHeader.h"
#import "TCSurePasswordController.h"
#import "WalletRequestManager.h"
#import "TCOutMiResultController.h"
#import <ethers/CloudKeychainSigner.h>
#import "MessageDbManager.h"
#import "JFNetworkingGetUserInfo.h"

@interface TCOutMiController ()<UITextFieldDelegate>

/// 对方账户输入框
@property (strong, nonatomic) UITextField *toAccountTextField;
/// 对方钱钱包地址输入框
@property (strong, nonatomic) UITextField *toWalletAddressTextField;
/// 币数输入框
@property (strong, nonatomic) UITextField *moneyValueTextField;
/// 自己钱包账户
@property (strong, nonatomic) UITextField *fromAccountTextField;
/// 钱包余额
//@property (strong, nonatomic) UITextField *fromAccountMoneyTextField;
/// 确定按钮
@property (strong, nonatomic) UIButton *sureButton;


@property (strong, nonatomic) NSString *selfWalletAddress;
@property (strong, nonatomic)  CloudKeychainSigner *selfSigner;

@end

@implementation TCOutMiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"能量交换";
    [self setupForDismissKeyboard];
    [self themeSetting];
    [self textChanged];
    
    
    [self getToUserInfo];
    //    [self queryWalletBalance];
}

#pragma mark - 获取对方信息
- (void)getToUserInfo{
    switch (self.type) {
        case TransferTypeFromDefault:
            break;
        case TransferTypeFromQRCode:{
            self.toAccountTextField.text = SafeString([self.toAddressInfo valueForKey:@"userId"]);
            self.toWalletAddressTextField.text = SafeString([self.toAddressInfo valueForKey:@"ethAddress"]);
            self.toAccountTextField.enabled = NO;
            self.toWalletAddressTextField.enabled = NO;
            if ([self.toAddressInfo.allKeys containsObject:@"money"] && !StringIsEmpty([self.toAddressInfo valueForKey:@"money"]) && ![[self.toAddressInfo valueForKey:@"money"] isEqualToString:@"0"]) {
                self.moneyValueTextField.text = [self.toAddressInfo valueForKey:@"money"];
                self.moneyValueTextField.enabled = NO;
            }
            [self textChanged];
        }
            break;
        case TransferTypeFromChat:{
            [self requestEthAddress:self.toUserId];
        }
            break;
            
        default:
            break;
    }
}

- (void)requestEthAddress:(NSString *)imUserId{
    MessageDbManager *dbMn = [[MessageDbManager alloc] init];
    NSMutableDictionary *userDic = [dbMn selectUserInfor:[self.toUserId intValue]];
    self.toAccountTextField.text = SafeString(self.toUserId);
    self.toAccountTextField.enabled = NO;
    self.toWalletAddressTextField.enabled = NO;
    
    if (!StringIsEmpty([userDic valueForKey:@"ethAddress"]) && ![[userDic valueForKey:@"ethAddress"] isEqualToString:@"(null)"]) {
        self.toWalletAddressTextField.text = SafeString([userDic valueForKey:@"ethAddress"]);
    }else{
        WEAK(self)
        [self showTCHUDWithTitle:@"正在获取基地ID"];
        [JFNetworkingGetUserInfo getUserEthAddressWithIMUserId:imUserId Success:^(NSString *ethAddress) {
            [weakself hiddenTCHUD];
            weakself.toWalletAddressTextField.text = SafeString(ethAddress);
        } fail:^(NSString *error) {
            [weakself hiddenTCHUD];
            [weakself showSystemAlertWithTitle:@"提示" message:@"基地ID获取失败，请重试"];
        }];
    }
    
}


//#pragma mark - 请求钱包余额
//- (void)queryWalletBalance{
//    [self showTCHUDWithTitle:@"请求能量余额"];
//    NSArray *addresses = @[self.selfWalletAddress];
//    WEAK(self)
//    [WalletRequestManager queryBalancesWithAddresses:addresses success:^(id result) {
//        [weakself hiddenTCHUD];
//        if ([[result valueForKey:@"result"] isEqualToString:@"success"] ) {
//            NSDictionary *balances = [result valueForKey:@"balances"];
//            [balances enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//                if ([self.selfWalletAddress isEqualToString:(NSString *)key]) {
//                    NSString *num = [NSString stringWithFormat:@"%@",obj];
//                    NSString *balance = [WalletManager milletToBalance:num];
//                    self.fromAccountMoneyTextField.text = balance;
//                }
//            }];
//        }else{
//            [weakself showSystemAlertWithTitle:@"提示" message:@"获取能量失败,请重试"];
//        }
//    } fail:^(NSString *errorDescription) {
//        [weakself hiddenTCHUD];
//        [weakself showSystemAlertWithTitle:@"提示" message:@"获取能量失败,请重试"];
//    }];
//}



#pragma mark - 当控制器View加载完成的时候，弹出内容View
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.toAccountTextField becomeFirstResponder];
}

#pragma mark - 确认按钮事件
- (void)sureButtonAction{
    [self.view endEditing:YES];
    WEAK(self)
    [TCSurePasswordController showWithSuperVc:self isRight:^(BOOL isSuccess,NSString * password) {
        if (isSuccess) {
            NSString *toPhone = self.toAccountTextField.text;
            NSString *toAddress = self.toWalletAddressTextField.text;
            NSString *value = self.moneyValueTextField.text;
            
            TCOutMiResultController *nextVc = [TCOutMiResultController new];
            nextVc.toPhone = toPhone;
            nextVc.toAddress = toAddress;
            nextVc.password = password;
            nextVc.moneyValue = value;
            nextVc.fromWalletAddress = weakself.selfWalletAddress;
            nextVc.signer = weakself.selfSigner;
            nextVc.type = weakself.type;
            [weakself.navigationController pushViewController:nextVc animated:YES];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.toAccountTextField]) {
        [self.toWalletAddressTextField becomeFirstResponder];
    }else if ([textField isEqual:self.toWalletAddressTextField]) {
        [self.moneyValueTextField becomeFirstResponder];
    }else if ([textField isEqual:self.moneyValueTextField]) {
        [self.moneyValueTextField resignFirstResponder];
    }
    return YES;
}


#pragma mark - 输入框文字变动
- (void)textChanged{
    if (self.toAccountTextField.text.length > 0 && self.toWalletAddressTextField.text.length > 0 && self.moneyValueTextField.text.length > 0) {
        self.sureButton.enabled = YES;
        self.sureButton.alpha = 1;
    }else{
        self.sureButton.enabled = NO;
        self.sureButton.alpha = 0.4;
    }
    
    NSString *money = self.moneyValueTextField.text;
    if ([money containsString:@"."]) {
        NSUInteger location = [money rangeOfString:@"."].location;
        NSUInteger lastLength = money.length - location;
        if (lastLength > 8) {
            self.moneyValueTextField.text = [money substringToIndex:location + 9];
        }
        
        if (location == 0) {
            self.moneyValueTextField.text = [NSString stringWithFormat:@"0%@",money];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    /*
     1.start with zero 0000.....was forbiden
     2.have no '.' & the first character is not '0'
     3.limit the count of '.'
     4.if the first character is '0',then the next one must be '.'
     5.condition like "0.0.0"was forbiden
     6.limit the num of zero after '.'
     */
    if ([textField isEqual:self.moneyValueTextField]) {
        if(((string.intValue<0) || (string.intValue>9))){
            //MyLog(@"====%@",string);
            if ((![string isEqualToString:@"."])) {
                return NO;
            }
            return NO;
        }
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        
        NSInteger dotNum = 0;
        NSInteger flag=0;
        const NSInteger limited = 8;
        if((int)futureString.length>=1){
            
            if([futureString characterAtIndex:0] == '.'){//the first character can't be '.'
                return NO;
            }
            if((int)futureString.length>=2){//if the first character is '0',the next one must be '.'
                if(([futureString characterAtIndex:1] != '.'&&[futureString characterAtIndex:0] == '0')){
                    return NO;
                }
            }
        }
        NSInteger dotAfter = 0;
        for (int i = (int)futureString.length-1; i>=0; i--) {
            if ([futureString characterAtIndex:i] == '.') {
                dotNum ++;
                dotAfter = flag+1;
                if (flag > limited) {
                    return NO;
                }
                if(dotNum>1){
                    return NO;
                }
            }
            flag++;
        }
        if(futureString.length - dotAfter > 7){
            //[MBProgressHUD toastMessage:@"超出最大金额"];
            return NO;
        }
        return YES;
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 主题设置
- (void)themeSetting{
    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
    
    self.toAccountTextField.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];
    self.toWalletAddressTextField.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];
    self.moneyValueTextField.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];
    self.fromAccountTextField.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];
    //    self.fromAccountMoneyTextField.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];
    
    self.toAccountTextField.theme_textColor  = [UIColor theme_colorPickerForKey:@"walletTransferTextFieldColor" fromDictName:@"opMe"];
    self.toWalletAddressTextField.theme_textColor = [UIColor theme_colorPickerForKey:@"walletTransferTextFieldColor" fromDictName:@"opMe"];
    self.moneyValueTextField.theme_textColor = [UIColor theme_colorPickerForKey:@"walletTransferTextFieldColor" fromDictName:@"opMe"];
    
    self.fromAccountTextField.theme_textColor  = [UIColor theme_colorPickerForKey:@"textFieldPlaceHolderColor" fromDictName:@"login"];
    //    self.fromAccountMoneyTextField.theme_textColor  = [UIColor theme_colorPickerForKey:@"tipColor" fromDictName:@"opMe"];
    
    self.toAccountTextField.theme_attributePlaceHolder = [NSAttributedString theme_attributeStringWithString:@"请输入对方星际ID"attributeColor:[UIColor theme_colorPickerForKey:@"textFieldPlaceHolderColor" fromDictName:@"login"]];
    self.toWalletAddressTextField.theme_attributePlaceHolder = [NSAttributedString theme_attributeStringWithString:@"请输入对方基地ID"attributeColor:[UIColor theme_colorPickerForKey:@"textFieldPlaceHolderColor" fromDictName:@"login"]];
    self.moneyValueTextField.theme_attributePlaceHolder = [NSAttributedString theme_attributeStringWithString:@"请输入能量数"attributeColor:[UIColor theme_colorPickerForKey:@"textFieldPlaceHolderColor" fromDictName:@"login"]];
    
    [self.sureButton setTitle:@"能量交换" forState:UIControlStateNormal];
    self.fromAccountTextField.text = [self.selfWalletAddress stringByReplacingCharactersInRange:NSMakeRange(6, self.selfWalletAddress.length-10) withString:@"****"];;
}

#pragma mark - lazyload
- (UITextField *)toAccountTextField{
    if (!_toAccountTextField) {
        _toAccountTextField = [UITextField new];
        _toAccountTextField.borderStyle = UITextBorderStyleNone;
        _toAccountTextField.font = FONT(15);
        _toAccountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_toAccountTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        _toAccountTextField.delegate = self;
        _toAccountTextField.textColor = cWhiteColor;
        _toAccountTextField.returnKeyType = UIReturnKeyNext;
        [_toAccountTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_toAccountTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];;
        [self.view addSubview:_toAccountTextField];
        [_toAccountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(16);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@45);
        }];
        
        [self addBottomLineAndLeftTitleWithTextField:_toAccountTextField leftTitle:@"  接收星际ID:"];
        
        
    }
    return _toAccountTextField;
}
- (UITextField *)toWalletAddressTextField{
    if (!_toWalletAddressTextField) {
        _toWalletAddressTextField = [UITextField new];
        _toWalletAddressTextField.backgroundColor = cWhiteColor;
        _toWalletAddressTextField.borderStyle = UITextBorderStyleNone;
        _toWalletAddressTextField.font = FONT(15);
        _toWalletAddressTextField.delegate = self;
        _toWalletAddressTextField.textColor = cWhiteColor;
        _toWalletAddressTextField.returnKeyType = UIReturnKeyNext;
        _toWalletAddressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_toWalletAddressTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_toWalletAddressTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_toWalletAddressTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];;
        [self.view addSubview:_toWalletAddressTextField];
        [_toWalletAddressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toAccountTextField.mas_bottom);
            make.left.right.equalTo(self.toAccountTextField);
            make.height.equalTo(@45);
        }];
        
        [self addBottomLineAndLeftTitleWithTextField:_toWalletAddressTextField leftTitle:@"  接收基地ID:"];
        
    }
    return _toWalletAddressTextField;
}
- (UITextField *)moneyValueTextField{
    if (!_moneyValueTextField) {
        _moneyValueTextField = [UITextField new];
        _moneyValueTextField.backgroundColor = cWhiteColor;
        _moneyValueTextField.borderStyle = UITextBorderStyleNone;
        _moneyValueTextField.font = FONT(15);
        _moneyValueTextField.delegate = self;
        _moneyValueTextField.textColor = cWhiteColor;
        _moneyValueTextField.returnKeyType = UIReturnKeyNext;
        _moneyValueTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _moneyValueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_moneyValueTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];;
        [self.view addSubview:_moneyValueTextField];
        [_moneyValueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toWalletAddressTextField.mas_bottom);
            make.left.right.equalTo(self.toAccountTextField);
            make.height.equalTo(@45);
        }];
        
        [self addBottomLineAndLeftTitleWithTextField:_moneyValueTextField leftTitle:@"  能量:"];
        
    }
    return _moneyValueTextField;
}

- (UITextField *)fromAccountTextField{
    if (!_fromAccountTextField) {
        _fromAccountTextField = [UITextField new];
        _fromAccountTextField.backgroundColor = cWhiteColor;
        _fromAccountTextField.borderStyle = UITextBorderStyleNone;
        _fromAccountTextField.font = FONT(16);
        _fromAccountTextField.delegate = self;
        _fromAccountTextField.enabled = NO;
        _fromAccountTextField.textColor = cWhiteColor;
        _fromAccountTextField.returnKeyType = UIReturnKeyNext;
        _fromAccountTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _fromAccountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view addSubview:_fromAccountTextField];
        [_fromAccountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.moneyValueTextField.mas_bottom).offset(16);
            make.left.right.equalTo(self.toAccountTextField);
            make.height.equalTo(@45);
        }];
        
        
        UIView *bottomLine = [UIView new];
        bottomLine.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"separatorColor"];
        [_fromAccountTextField addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_fromAccountTextField).inset(-3);
            make.bottom.equalTo(_fromAccountTextField);
            make.height.equalTo(@1);
        }];
        
        NSString *title = @"  转出基地ID:";
        CGFloat width = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 45) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(17)} context:nil].size.width;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, width + 20, 45)];
        titleLabel.text = title;
        titleLabel.theme_textColor =  [UIColor theme_colorPickerForKey:@"textFieldPlaceHolderColor" fromDictName:@"login"];
        titleLabel.font = FONT(17);
        _fromAccountTextField.leftView = titleLabel;
        _fromAccountTextField.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return _fromAccountTextField;
}
//
//- (UITextField *)fromAccountMoneyTextField{
//    if (!_fromAccountMoneyTextField) {
//        _fromAccountMoneyTextField = [UITextField new];
//        _fromAccountMoneyTextField.backgroundColor = cWhiteColor;
//        _fromAccountMoneyTextField.borderStyle = UITextBorderStyleNone;
//        _fromAccountMoneyTextField.font = FONT(15);
//        _fromAccountMoneyTextField.delegate = self;
//        _fromAccountMoneyTextField.enabled = NO;
//        _fromAccountMoneyTextField.returnKeyType = UIReturnKeyNext;
//        _fromAccountMoneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
//        _fromAccountMoneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [self.view addSubview:_fromAccountMoneyTextField];
//        [_fromAccountMoneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.fromAccountTextField.mas_bottom);
//            make.left.right.equalTo(self.toAccountTextField);
//            make.height.equalTo(@45);
//        }];
//
//
//        UIView *bottomLine = [UIView new];
//        bottomLine.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"separatorColor"];
//        [_fromAccountMoneyTextField addSubview:bottomLine];
//        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(_fromAccountMoneyTextField).inset(-3);
//            make.bottom.equalTo(_fromAccountMoneyTextField);
//            make.height.equalTo(@1);
//        }];
//
//        NSString *title = @"  能量余额:";
//        CGFloat width = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 45) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(17)} context:nil].size.width;
//
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, width + 20, 45)];
//        titleLabel.text = title;
//        titleLabel.theme_textColor =  [UIColor theme_colorPickerForKey:@"textFieldPlaceHolderColor" fromDictName:@"login"];
//        titleLabel.font = FONT(17);
//        _fromAccountMoneyTextField.leftView = titleLabel;
//        _fromAccountMoneyTextField.leftViewMode = UITextFieldViewModeAlways;
//
//    }
//    return _fromAccountMoneyTextField;
//}


- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _sureButton.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"nextButtonBgColor" fromDictName:@"login"];
        _sureButton.theme_tintColor  = [UIColor theme_colorPickerForKey:@"nextButtonTintColor" fromDictName:@"login"];
        _sureButton.layer.cornerRadius = 22.5;
        [_sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sureButton];
        [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view).inset(10);
            make.top.equalTo(self.fromAccountTextField.mas_bottom).offset(20);
            make.height.equalTo(@45);
        }];
    }
    return _sureButton;
}

- (NSString *)selfWalletAddress{
    if (!_selfWalletAddress) {
        Wallet *wallet = [WalletManager sharedWallet];
        self.selfSigner = (CloudKeychainSigner *)[wallet.accounts objectAtIndex:wallet.activeAccountIndex];;
        Address *address = self.selfSigner.address;
        _selfWalletAddress = [address checksumAddress];
    }
    return _selfWalletAddress;
}


#pragma mark - UITextField添加底部线和标题
- (void)addBottomLineAndLeftTitleWithTextField:(UITextField *)textField leftTitle:(NSString *)title{
    UIView *bottomLine = [UIView new];
    bottomLine.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"separatorColor"];
    [textField addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(textField).inset(-3);
        make.bottom.equalTo(textField);
        make.height.equalTo(@1);
    }];
    
    CGFloat width = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 45) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(17)} context:nil].size.width;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 110, 45)];
    titleLabel.text = title;
    titleLabel.textColor = cDarkGrayColor;
    titleLabel.theme_textColor  = [UIColor theme_colorPickerForKey:@"cellTitle"];
    titleLabel.font = FONT(17);
    textField.leftView = titleLabel;
    textField.leftViewMode = UITextFieldViewModeAlways;
}


@end

