//
//  AppDelegate.m
//  OSPMobile
//
//  Created by Javor on 16/3/16.
//  Copyright (c) 2016年 Pansoft. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import <Bugly/Bugly.h>
#import "MainTabBarController.h"
#import "EnvironmentVariable.h"
#import "EAI.h"
#import "FileUtil.h"
#import "VersionUtil.h"
#import "Registry.h"
#import "ViewControllerManager.h"
#import "JFMessageManager.h"
#import "EFChatLeftViewController.h"
#import "EFChatHttpManager.h"
#import "Constant.h"
#import "EFMessageService.h"
#import "ReadPlistFile.h"
#import "AFNetworkReachabilityManager.h"
#import "EFDeviceUtil.h"
#import "MBProgressHUD.h"
#import "URLUtil.h"
#import "TCInputPhoneController.h"
#import <ethers/Wallet.h>
#import <ethers/SecureData.h>
#import "SettingFileManager.h"
#import "LoginViewController.h"
#import <ethers/WalletManager.h>
#import <ethers/Account.h>

#import <ethers/CloudKeychainSigner.h>
#import "StringUtil.h"
#import "UIImage+Category.h"
#import "EFXHNavigationController.h"
#import "TalkChainHeader.h"
#import "ThemeKit.h"
#import "EFGuideView.h"
#import <AMapFoundationKit/AMapServices.h>
#import "TCTools.h"
#import "EFCheckVersionUtil.h"
#import "YYRSACrypto.h"
#import "SystemShareToFriendController.h"
#import "EFShareController.h"
#import "SystemShareController.h"
#import "TCInputPhoneController.h"
#import "TCUploadAvatarController.h"
#import "TCUploadFansController.h"
#import "NotificationUtil.h"
#import "SystemShareUtil.h"
#import "AppearanceUtil.h"
#import "AmapUtil.h"
#import "WalletUtil.h"
#import "GuideViewUtil.h"
#import "ResourceUtil.h"
#import "EnvironmentUtil.h"


@interface AppDelegate ()<UNUserNotificationCenterDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) EFChatHttpManager   *offlineHttpManager;

@end

@implementation AppDelegate 


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 1.注册推送
    [NotificationUtil registerNotificationWithApplication:application notificationDelagte:self];
    // 2.注册友盟分享
    [EFShareController sharemanager];
    // 3.注册bugly
    [Bugly startWithAppId:@"08c0e19ba5"];
    // 4.注册搞得地图
    [AmapUtil registerAmap];
    // 5.tableView全局设置
    [AppearanceUtil tableViewAppearance];
    // 6.设置默认主题
    [ThemeManager changeToThemeWithThemeName:@"ThemeDark"];

    // 拷贝bundle里面的plist到本地
    [ResourceUtil copyBundleResourcePlistToSanbox];
    // 拷贝资源文件到沙盒
    [SettingFileManager copyConfigSettinBundleToDefaultPath];
    //设置环境变量
    [EnvironmentUtil setupEnvironmentVariable];
    // 获取Package
    [FileUtil getPackageFiles];
    // 保存是否是ipx
    [EnvironmentUtil saveIsIphoneX];
    //社会化分享
    
    
    
    [EnvironmentVariable setVersionPath:@"Package"];

    // 设置基地标题
    [self setJDTitle];
    // 懒加载并设置rootVc
    self.window.rootViewController = [UIViewController new];
    // 引导页
    [GuideViewUtil showGuideView];

    return YES;
}

#pragma mark - 设置基地标题
- (void)setJDTitle{
    StubObject *st = [Registry getStubObjectForKey:@"jidi2"];
    NSString *planet = [EnvironmentVariable getPropertyForKey:@"planet" WithDefaultValue:@"earth"];
    NSString *nameBase =  [TCTools getZhPlanetBaseNameWithEnName:planet];
    [st setValue:nameBase forKey:@"caption"];
}

#pragma mark - 根据登录步骤去上次没完成的界面
- (void)goLastStepControllerByLoginStep{
    LoginStep step = [[EnvironmentVariable getPropertyForKey:LOGIN_STEP WithDefaultValue:@"0"] integerValue];
    switch (step) {
        case LoginStepDefault:{
            TCInputPhoneController *loginVc = [[TCInputPhoneController alloc] init];
            [self goStepController:loginVc];
        }
            break;
        case LoginStepNoAvatar:{
            TCUploadAvatarController *uploadAvatarVc = [[TCUploadAvatarController alloc] init];
            [self goStepController:uploadAvatarVc];
        }
            break;
        case LoginStepNoFans:{
            TCUploadFansController *uploadFansVc = [[TCUploadFansController alloc] init];
            uploadFansVc.type = UploadFansTypeRegister;
            [self goStepController:uploadFansVc];
        }
            break;
        case LoginStepLoginSuccess:{
            [self goMainView];
            [SystemShareUtil showShareController];
        }
            break;
        default:
            break;
    }
}


#pragma mark - 设置到指定的控制器为RootController
- (void)goStepController:(UIViewController *)vc{
    EFXHNavigationController *nvc = [[EFXHNavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBar.theme_barStyle = [NSString theme_stringForKey:@"barStyle" fromDictName:@"navigationBar"];
    nvc.navigationBar.theme_tintColor = [UIColor theme_navigationBarColorPickerForKey:@"tintColor"];
    nvc.navigationBar.theme_barTintColor = [UIColor theme_navigationBarColorPickerForKey:@"barTintColor"];
    nvc.navigationBar.translucent = NO;
    KEYWINDOW.rootViewController = nvc;
}

#pragma mark - 退出登录
- (void)logout{
    [USERDEFAULT removeObjectForKey:@"updateHint"];
    [WalletManager setSharedWallet:nil];
    [EnvironmentVariable removePropertyForKey:@"access_token"];
    [EnvironmentVariable setProperty:@(LoginStepDefault) forKey:LOGIN_STEP];
    TCInputPhoneController *loginVc = [[TCInputPhoneController alloc] init];
    [self goStepController:loginVc];
}

#pragma mark - 进入主界面
-(void)goMainView {
    //option.xml自定义颜色
    NSString *colorString = [[[Registry getStubObjectForKey:@"customColor"] getStubTable] objectForKey:@"color"];
    if (colorString != nil) {
        [EnvironmentVariable setProperty:colorString forKey:@"customColor"];
    }
    self.left = [[EFChatLeftViewController alloc] init];


    NSString *IMpath = [[NSBundle mainBundle] pathForResource:@"OptionSetting.plist" ofType:nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:IMpath];
    NSString *IM = dic[@"IMBaseUrl"];
    [JFSocketManager sharedSocketManager].imURL = IM;

    //确保先执行service中消息的代理方法
    EFMessageService *service = [EFMessageService sharedMessageService];
    [service connectManager];
    [service prepareOpeartion];
    [[JFMessageManager sharedMessageManager] addMessageDelegate:service];
    [service unreadcountRefresh];


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

    [[JFMessageManager sharedMessageManager] addMessageDelegate:self];
    [[JFMessageManager sharedMessageManager].messageDBManager updateDataBaseTablesInfo];

    // 发送上线消息
    [[JFMessageManager sharedMessageManager] doConnect];

    //网络监控句柄
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];

    // 兼容旧版本没有通讯公钥
    [WalletUtil compatibleComPrivateKey];

    Wallet *wallet = [WalletManager sharedWallet];
    if(AccountNotFound == wallet.activeAccountIndex) {
        [self logout];
    }else {
        self.tabbarController = [[MainTabBarController alloc] init];
        _tabbarController.leftView = _left.view;
        _tabbarController.selectedIndex = [self selectedIndex];
        self.window.rootViewController = nil;
        self.window.rootViewController = _tabbarController;
        [ViewControllerManager setMainTabbarController:_tabbarController];
    }
}



- (NSInteger)selectedIndex {
    NSString *selectIndex = [EnvironmentVariable getPropertyForKey:@"defaultDisplay" WithDefaultValue:nil];
    if (selectIndex) {
        return [selectIndex integerValue];
    }
    NSMutableArray *array = [Registry getRegEntryListWithKey:@"menuRoot"];
    for (NSInteger i = 0; i<array.count; i++) {
        StubObject *stub = array[i];
        if ([[stub.stubTable objectForKey:@"defaultDisplay"] isEqualToString:@"true"]) {
            return i;
        }
    }
    return 0;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    [EnvironmentVariable setDeviceToken:hexToken];
}

// iOS 10收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{

    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// 通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
    } else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler();
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if(![EnvironmentVariable getPropertyForKey:@"access_token" WithDefaultValue:nil]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        return;
    }
    NSString *badge = [NSString stringWithFormat:@"%ld", (long)[self unreadcountRefresh]];

    [UIApplication sharedApplication].applicationIconBadgeNumber = [badge integerValue];
    [[JFSocketManager sharedSocketManager] stopConnect];
    NSString *userId = [EnvironmentVariable getIMUserID];
    NSString *pwd = [EnvironmentVariable getIMPassword];
    NSString *token = [EnvironmentVariable getDeviceToken];
    NSString *deviceId = [EnvironmentVariable getPropertyForKey:@"UUID" WithDefaultValue:@""];
    NSString *disturb = [EnvironmentVariable getPropertyForKey:EF_DISTURB WithDefaultValue:@""];
    NSString *apnsPush = @"";
    if ([disturb isEqualToString:@"YES"]) {
        apnsPush = @"0";
    } else if ([disturb isEqualToString:@"NO"] || [disturb isEqualToString:@""]) {
        apnsPush = @"1";
    }
    [self.offlineHttpManager HttpRequestForOfflineWithUserId:userId userPassword:pwd deviceToken:token badge:badge deviceId:deviceId apnsPush:apnsPush];
}

- (NSInteger)unreadcountRefresh {
    MainTabBarController *tab = [ViewControllerManager getMainTabbarController];
    NSMutableArray *array = [Registry getRegEntryListWithKey:@"menuRoot"];
    NSInteger badge=0;
    for (NSInteger i = 0; i<array.count; i++) {
        badge = badge + [[tab.tabBar.items objectAtIndex:i].badgeValue integerValue];
    }
    return badge;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if(![EnvironmentVariable getPropertyForKey:@"access_token" WithDefaultValue:nil])  return;
    [[JFSocketManager sharedSocketManager] startConnect];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark - 其他软件跳转进来
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if ([url.absoluteString isEqualToString: AppKey]) {
        self.isSystemShare = YES;
        LoginStep step = [[EnvironmentVariable getPropertyForKey:LOGIN_STEP WithDefaultValue:@"0"] integerValue];

        if ([KEYWINDOW.rootViewController isKindOfClass:[MainTabBarController class]] && step == LoginStepLoginSuccess) {
            [SystemShareUtil showShareController];
        }
    }else{
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    return YES;
}


#pragma mark - 懒加载

- (EFChatHttpManager *)offlineHttpManager {
    if (!_offlineHttpManager) {
        _offlineHttpManager = [[EFChatHttpManager alloc] init];
    }
    return _offlineHttpManager;
}

- (UIWindow *)window{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = cWhiteColor;
        [_window makeKeyAndVisible];
    }
    return _window;
}

@end

