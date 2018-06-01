//
//  LoginViewController.m
//  YTAutoLayout
//
//  Created by fly on 14/12/12.
//  Copyright (c) 2014年 fly. All rights reserved.
//

#import "LoginViewController.h"
#import "EAI.h"
#import "URLUtil.h"
#import "Registry.h"
#import "VersionUtil.h"
#import "EnvironmentVariable.h"
#import "FileUtil.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "Reachability.h"
#import "Masonry.h"
#import "StubObject.h"
#import "JFMessageManager.h"
#import "MessageDbManager.h"
#import "EFChatHttpManager.h"
#import "PersonModel.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "EFMessageService.h"
#import "ReadPlistFile.h"

@interface LoginViewController ()<UITextFieldDelegate, LoginViewDelegate, UIAlertViewDelegate, JFMessageManagerDelegate, JFSocketManagerDelegate, EFLoginManagerDelegate>
@property(nonatomic,strong) EFChatHttpManager *httpManager;
@end

@implementation LoginViewController {
    BOOL                        isAddressSuccess;
    BOOL                        isPublicSuccess;
    BOOL                        isGroupSuccess;
    BOOL                        isUserSuccess;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubviews];
}

#pragma mark -Lazy
-(EFChatHttpManager *)httpManager {
    if (!_httpManager) {
        _httpManager = [[EFChatHttpManager alloc]init];
    }
    return _httpManager;
}

// 创建视图
- (void)createSubviews {
    // 登录界面
    LoginView *view = [[LoginView alloc] init];
    self.controllerModels = [NSMutableArray array];
    _loginManager = [[EFLoginManager alloc] init];
    _loginManager.delegate = self;
    _loginManager.eventsViewController = (UIViewController *)self;
    _loginView = view;
    self.view = _loginView;
    
    //登录界面--上方图标
    UIImage * headerImage = efImageFromBundleWithPathAndType(ChatImgBundle, @"/image_login&register/chat_image_login_header", @"png"); //[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ChatImgBundle.bundle/image_login&register/chat_image_login_header.png"]];
    UIImageView * headerImageView = [[UIImageView alloc] initWithImage:headerImage];
    [_loginView addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_loginView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(headerImage.size.width * 0.5, headerImage.size.height * 0.5));
    }];
    //登录界面--上方文字
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = app_Name;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [_loginView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_loginView.textName.mas_top).with.offset(-10);
        make.top.equalTo(headerImageView.mas_bottom).with.offset(5);
        make.centerX.mas_equalTo(_loginView.mas_centerX);
    }];
    //登录界面--注册按钮
    UIButton * registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"注 册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerButton setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1]];
    registerButton.layer.shadowOffset = CGSizeMake(1, 1);
    registerButton.layer.shadowColor = [UIColor blackColor].CGColor;
    registerButton.layer.shadowOpacity = 0.8;
    registerButton.layer.shadowRadius = 1;
    [registerButton addTarget:self action:@selector(clickRegister) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginView.savePwd.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(_loginView.mas_centerX);
        make.width.mas_equalTo(80);
    }];
    //loginview自带控件
    _loginView.textName.returnKeyType = UIReturnKeyNext;
    _loginView.textName.delegate = self;
    //设置tag属性
    UIImage * userImage = efImageFromBundleWithPathAndType(ChatImgBundle, @"/image_login&register/chat_image_login_username", @"png");//[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ChatImgBundle.bundle/image_login&register/chat_image_login_username.png"]];
    _loginView.textName.leftView = [[UIImageView alloc] initWithImage:userImage];
    _loginView.textName.tag = 1001;
    _loginView.textPwd.tag = 1002;
    UIImage * pwdImage = efImageFromBundleWithPathAndType(ChatImgBundle, @"/image_login&register/chat_image_login_password", @"png");//[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ChatImgBundle.bundle/image_login&register/chat_image_login_password.png"]];
    _loginView.textPwd.leftView = [[UIImageView alloc] initWithImage:pwdImage];
    //设置控制器为代理
    _loginView.textPwd.delegate = self;
    _loginView.delegate = self;
    //获取用户名密码；
    self.userName = _loginView.textName.text;
    self.userPwd = _loginView.textPwd.text;
    self.autoLogin = _loginView.autoLogin;
    self.savePwd = _loginView.savePwd;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(self.savePwd.isOn) {
        _loginView.textName.text = [userDefaults objectForKey:@"username"];
        _loginView.textPwd.text =  [userDefaults objectForKey:@"password"];
    } else {
        _loginView.textName.text = [userDefaults objectForKey:@"username"];
        _loginView.textPwd.text =  @"";
    }
    self.userName = _loginView.textName.text;
    self.userPwd = _loginView.textPwd.text;
}

#pragma mark - 点击注册按钮
- (void)clickRegister {
//    EFChatRegisterViewController *regis = [[EFChatRegisterViewController alloc] init];
//    regis.delegate = self;
//    UINavigationController * navigationVC = [[UINavigationController alloc] initWithRootViewController:regis];
//    [self presentViewController:navigationVC animated:YES completion:nil];
}

#pragma mark - EFChatRegisterDelegate
- (void)backcRegisterUserId:(NSString *)userId {
    self.loginView.textName.text = userId;
    self.loginView.textPwd.text = @"";
}

#pragma mark - 点击键盘完成按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1001) {
        [textField resignFirstResponder];
        [_loginView.textPwd becomeFirstResponder];
    }
    return YES;
}

#pragma mark - LoginViewDelegate
//点击登录  保存用户名
- (void)doLogin:(LoginView *)loginView {
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    NSString *isLoginFailed = [userDefs objectForKey:@"loginfailed"];
    if (isLoginFailed != nil && [isLoginFailed isEqualToString:@"failed"]) {
        [self againLogin];
    }else{
        _userName = self.loginView.textName.text;
        _userPwd = self.loginView.textPwd.text;
        [userDefs setObject:self.userName forKey:@"username"];
        [self.loginView endEditing:YES];
        // 先判断是否为空，不为空 执行登录操作
        if (_userName.length == 0 || _userPwd.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        } else {
            [_loginManager panLoginWithUserName:_userName password:_userPwd];
        }
    }
}

#pragma mark -  EFLoginManagerDelegate getLoginResponseMap
- (void)getLoginResponseMap:(NSDictionary *)mapDict {
    self.mapDict = mapDict;
}

#pragma mark - EFLoginManagerDelegate getAppUpdateUrl
- (void)getAppUpdateUrl:(NSString *)updateUrl {
    self.updateURL = updateUrl;
}

#pragma mark - EFLoginManagerDelegate delegateCreateWebView
- (void)delegateCreateWebView {
    [self createWebView];
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *updateUrl = [NSString stringWithFormat:@"%@%@", @"itms-services://?action=download-manifest&url=", _updateURL];
    NSURL *url = [NSURL URLWithString:updateUrl];
    [[UIApplication sharedApplication] openURL:url];
    return;
}

- (void)createWebView {
    [FileUtil getPackageFiles];
    [self loginSucess];
    [self isFirstLoading];
}

- (void)webBrowserFormCreated {
    [self loginSucess];
}

//登录成功
- (void)loginSucess {
    //保存用户密码
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if(self.userPwd.length > 0) {
        [ud setObject:self.userPwd forKey:@"password"];
    }
    [[JFMessageManager sharedMessageManager] addMessageDelegate:self];
    NSString *IMpath = [[NSBundle mainBundle] pathForResource:@"OptionSetting.plist" ofType:nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:IMpath];
    NSString *IM = dic[@"IMBaseUrl"];
    [JFSocketManager sharedSocketManager].imURL = IM;
    // 发送上线消息
//    [[JFMessageManager sharedMessageManager] doConnect];
//    [ud setObject:imUserId forKey:@"IMUserID"];
    NSLog(@"--》发送上线消息");
}

///上线消息 回调
- (void)onMessageManagerDidConnect:(JFMessageManager *)messageManager {
    [[JFMessageManager sharedMessageManager] removeMessageDelegate:self];
    EFMessageService *service = [EFMessageService sharedMessageService];
    [service connectManager];
    [service prepareOpeartion];
    [self isFirstLoading];
    NSLog(@"--》上线成功");
}

- (void)againLogin {
    [self showHudView:@"正在登录..."];
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setObject:@"againLogin" forKey:@"loginfailed"];
    [self isFirstLoading];
}

- (void)isFirstLoading {
    MessageDbManager * manager = [[MessageDbManager alloc] init];
    [manager createDataBase];
    // 默认铃声、震动设置
    // 免打扰
    NSString *bother = [EnvironmentVariable getPropertyForKey:EF_DISTURB WithDefaultValue:@""];
    // 播放声音
    NSString *playsound = [EnvironmentVariable getPropertyForKey:EF_PLAYSOUND WithDefaultValue:@""];
    // 播放震动
    NSString *playVibrate = [EnvironmentVariable getPropertyForKey:EF_PLAYVIBRATE WithDefaultValue:@""];
    if ([bother isEqualToString:@""] && [playsound isEqualToString:@""] && [playVibrate isEqualToString:@""]) {
        [EnvironmentVariable setProperty:@"YES" forKey:EF_PLAYVIBRATE];
        [EnvironmentVariable setProperty:@"YES" forKey:EF_PLAYSOUND];
        [EnvironmentVariable setProperty:@"NO" forKey:EF_DISTURB];
    }
    NSString *userId = [EnvironmentVariable getIMUserID];
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    NSString *update = [userDefs objectForKey:@"updateHint"];
    if (update == nil || ![userId isEqualToString:update]) {
        //加载通讯录数据
        [self requesetChatAddressBookData];
        //加载群组数据
        [self requestGroupListData];
        //加载公众号信息
        [self requestPublicData];
        //加载群成员数据
        //    [self getGroupPeron];
        //加载个人信息
        [self requestSelfInfoData];
        
    }else{
        [self performLoading];
    }
}

- (void)performLoading {
    [EnvironmentVariable setPassWord:self.loginView.textPwd.text];
    [EnvironmentVariable setUser:self.loginView.textName.text];
    //    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //    [ud setObject:_loginView.textName.text forKey:@"username"];
    //    [ud setObject:_loginView.textPwd.text forKey:@"password"];
    [self hiddenHudView];
}

- (void)performLoadRootVC:(NSString *)type {
    if ([type isEqualToString:@"address"]) {
        isAddressSuccess = YES;
    }else if ([type isEqualToString:@"public"]){
        isPublicSuccess = YES;
    }else if ([type isEqualToString:@"group"]){
        isGroupSuccess = YES;
    }else if ([type isEqualToString:@"user"]){
        isUserSuccess = YES;
    }
    if (isAddressSuccess && isPublicSuccess && isGroupSuccess && isUserSuccess) {
        NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
        NSString *userId = [EnvironmentVariable getIMUserID];
        [userDefs setObject:userId forKey:@"updateHint"];
        [self performLoading];
    }
}

- (void)getDataFailure:(NSString *)reason {
    [self hiddenHudView];
    [self showTipHUDView:reason];
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setObject:@"failed" forKey:@"loginfailed"];
}

#pragma mark - 请求通讯录列表信息
- (void)requesetChatAddressBookData {
    MessageDbManager *messageDBManager = [[MessageDbManager alloc] init];
    NSString *userid = [EnvironmentVariable getIMUserID];
    NSString *password = [EnvironmentVariable getIMPassword];
    [self.httpManager HttpRequestForGettingAddressListUserId:userid userPassword:password success:^(id responseObject) {
        NSLog(@"请求通讯录数据成功");
        NSMutableArray *array = [NSMutableArray array];
        array = responseObject[@"addressList"];
        for (NSDictionary *addressDic in array) {
            PersonModel *model = [[PersonModel alloc] init];
            [model setValuesForKeysWithDictionary:addressDic];
            model.userName = addressDic[@"userName"];
            model.userId = [addressDic[@"userId"] intValue];
            model.mobilePhone = addressDic[@"mobilePhone"];
            model.remarkName = addressDic[@"note"];
            model.userType = 0;
            if (addressDic[@"nickName"]) {
                model.nickName = addressDic[@"nickName"];
            } else {
                model.nickName = addressDic[@"userName"];
            }
        }
        
        BOOL isOK = [messageDBManager insertIntoUserAndFriends:array loginUserId:[userid integerValue]];
        NSLog(@"isOK %d",isOK);
        [self performLoadRootVC:@"address"];
    } failure:^(NSString *error) {
        [self getDataFailure:@"请求用户数据失败，请重新登录"];
        NSLog(@"请求通讯录数据失败");
        
    }];
}

#pragma mark - 请求公众号信息
- (void)requestPublicData {
    MessageDbManager *messageDBManager = [[MessageDbManager alloc] init];
    NSString *userid = [EnvironmentVariable getIMUserID];
    NSString *password = [EnvironmentVariable getIMPassword];
    //加载公众号
    [self.httpManager HttpRequestForGettingPublicListUserId:userid userPassword:password success:^(id responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        array = responseObject[@"publics"];
        for (NSDictionary *infoDic in array) {
            PersonModel *model = [[PersonModel alloc] init];
            [model setValuesForKeysWithDictionary:infoDic];
            model.userName = infoDic[@"userName"];
            model.userId = [infoDic[@"userId"] intValue];
            model.userType = [infoDic [@"userType"] intValue];
            model.avatar = infoDic[@"avatar"];
            if (infoDic[@"nickName"]) {
                model.nickName = infoDic[@"nickName"];
            } else {
                model.nickName = infoDic[@"userName"];
            }
        }
        [messageDBManager insertIntoUserAndFriends:array loginUserId:[userid integerValue]];
        [self performLoadRootVC:@"public"];
        NSLog(@"请求公众号数据成功");
    } failure:^(NSString *error) {
        [self getDataFailure:@"请求用户数据失败，请重新登录"];
        NSLog(@"请求公众号数据失败");
    }];
}

#pragma mark - 请求群聊列表信息
- (void)requestGroupListData {
    // http://im.solarsource.cn/IMServer/group/getGroupListByUserId?userId=1&passWord=123456
    NSString *userid = [EnvironmentVariable getIMUserID];
    NSString *password = [EnvironmentVariable getIMPassword];
    [self.httpManager HttpRequestForGettingGroupListWithUserId:userid userPassword:password success:^(id responseObject) {
        NSLog(@"请求群组数据成功");
        NSMutableArray *chatGroupListArray = [NSMutableArray arrayWithCapacity:1];
        if (responseObject[@"groups"] == nil) {
            [self performLoadRootVC:@"group"];
            return ;
        }
        chatGroupListArray = responseObject[@"groups"];
        if (chatGroupListArray.count < 1) {
            [self performLoadRootVC:@"group"];
            return ;
        }
        MessageDbManager *messageDBManager = [[MessageDbManager alloc] init];
        for (NSInteger i = 0; i < chatGroupListArray.count; i++) {
            NSMutableDictionary *groupDictionary = [NSMutableDictionary dictionaryWithDictionary:chatGroupListArray[i]];
            //            NSArray *array = [[NSArray alloc] init];
            //            [groupDictionary setObject:array forKey:@"addUserIdArray"];
            [groupDictionary setObject:userid forKey:@"loginUserId"];
            [messageDBManager addChatGroup:groupDictionary];
        }
        [self performLoadRootVC:@"group"];
    } failure:^(NSString *error) {
        [self getDataFailure:@"请求用户数据失败，请重新登录"];
        NSLog(@"请求群组数据失败");
    }];
}

#pragma mark - 请求个人信息
- (void)requestSelfInfoData {
    [self.httpManager HttpRequestForGettingOtherUserInfoWithFriendId:[EnvironmentVariable getIMUserID] success:^(id responseObject) {
        NSDictionary *useDic = responseObject;
        NSDictionary *info = useDic[@"user"];
        NSString *avatar = info[@"avatar"];
        if (avatar != nil) {
            [EnvironmentVariable setProperty:avatar forKey:@"avatar"];
        }else{
            [EnvironmentVariable setProperty:@"" forKey:@"avatar"];
        }
        NSString *sign = info[@"sign"];
        if (sign != nil) {
            [EnvironmentVariable setProperty:sign forKey:@"sign"];
        }else{
            [EnvironmentVariable setProperty:@"" forKey:@"sign"];
        }
        NSString *sex = info[@"sex"];
        if (sex != nil && ![sex isEqualToString:@""] ) {
            [EnvironmentVariable setProperty:sex forKey:@"sex"];
        }else{
            [EnvironmentVariable setProperty:@"M" forKey:@"sex"];//公众号可能为nil暂设M
        }
        NSString *nickName = info[@"nickName"];
        if (nickName != nil) {
            [EnvironmentVariable setProperty:nickName forKey:@"nickName"];
        }else{
            [EnvironmentVariable setProperty:info[@"userName"] forKey:@"nickName"];
            
        }
        [EnvironmentVariable setProperty:info[@"userName"] forKey:@"userName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:updateLeftUserInfo object:self userInfo:info];
        MessageDbManager *messageDBManager = [[MessageDbManager alloc] init];
        [messageDBManager updateUserInfoWithUserInfoDic:info];
        [self performLoadRootVC:@"user"];
        NSLog(@"请求个人信息成功");
    } failure:^(NSString *error) {
        [self getDataFailure:@"请求用户数据失败，请重新登录"];
        NSLog(@"请求个人信息失败，%@", error);
    }];
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(!self.autoLogin.isOn) {
        [self.loginView.textName becomeFirstResponder];
    }
}

// 自动登录改变
- (void)autoDidChange:(UISwitch *)swt {
    NSUserDefaults *ud =  [NSUserDefaults standardUserDefaults];
    if (swt.isOn) {
        [ud setObject:@"1" forKey:@"autologin"];
        [ud setObject:@"1" forKey:@"savepwd"];
        [self.savePwd setOn:YES];
    } else {
        [ud setObject:@"0" forKey:@"autologin"];
    }
}

//改变保存密码
- (void)saveDidChange:(UISwitch *)swt {
    NSUserDefaults *ud =  [NSUserDefaults standardUserDefaults];
    //不保存密码
    if (!swt.isOn) {
        [ud setObject:@"0" forKey:@"savepwd"];
        [ud setObject:@"0" forKey:@"autologin"];
        [self.autoLogin setOn:NO];
        _loginView.textPwd.text = @"";
        [ud setObject:@"" forKey:@"password"];
    }else {
        //保存密码
        [ud setObject:@"1" forKey:@"savepwd"];
    }
}

- (void)showTipHUDView:(NSString *)str {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    [self.view addSubview:hud];
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(1.0);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
}

- (void)dealloc {
    _loginView = nil;
    _userName = nil;
    _userPwd = nil;
    _loginManager = nil;
    _mapDict = nil;
    _updateURL = nil;
    [[JFMessageManager sharedMessageManager] removeMessageDelegate:self];
}

@end
