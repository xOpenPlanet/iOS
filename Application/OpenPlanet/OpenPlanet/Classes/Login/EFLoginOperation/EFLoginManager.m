//
//  EFLoginManager.m
//  OSPMobile
//
//  Created by 虎 谢 on 16/12/4.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import "EFLoginManager.h"
#import "AppDelegate.h"
#import "StringUtil.h"
#import "VersionUtil.h"
#import "FileUtil.h"
#import "EAI.h"
#import "URLUtil.h"
#import "ZipArchive.h"
#import "MBProgressHUD.h"
#import "EnvironmentVariable.h"
#import "StubObject.h"
#import "UIViewController+Extension.h"
#import "JFMessageManager.h"
#import "AppDelegate.h"
#import "EFChatListViewController.h"
#import "EFAdaptationAlert.h"
#import "Reachability.h"
#import "ViewControllerManager.h"
#import "ViewTypeForTabbarIndex.h"
#import "MessageDbManager.h"
#import "EFMessageService.h"
#import "EFChatHttpManager.h"
#import "ReadPlistFile.h"
#import "EFRestfulLoginOperation.h"
#import "AFNetworkingManager.h"

#define tag_download_base_version   1000
#define tag_download_update_version 1001
#define kServerResource             @"res"
#define kBaseVersionName            @"BASE_VERSION_NAME"
#define kUpdateVersionName          @"UPDATE_VERSION_NAME"
#define kLocalResource              @"LOCAL_RESOURCE"
#define kPlisteDirectory            @"PLISTE"

@interface EFLoginManager() <EFAdaptationAlertDelegate, JFMessageManagerDelegate>

@property (nonatomic, copy) downloadComplete dComplete;
@property (nonatomic, retain) NSMutableDictionary *downloadParam;
@property (nonatomic, strong) NSMutableDictionary *verDic;
@property (nonatomic, strong) EFAdaptationAlert *alert;

// 用于记录每次下载基础资源文件大小
@property (nonatomic, copy) NSString *totalBytesWritten;
@property (nonatomic, assign) float updateFileLength;
// 用于记录每次下载资源文件大小
@property (nonatomic, copy) NSString *updateTotalBytesWritten;
@property (nonatomic, strong) EFChatHttpManager *manager;
// restful登录
@property (nonatomic, strong) EFRestfulLoginOperation *restfulLoginOperation;
// 存放app版本信息与资源文件信息的字典
@property (nonatomic, strong) NSMutableDictionary *appVersionInfoDic;

// --  17年10月25日 --
// 首次登录加载资源文件的提示框
@property (nonatomic, strong) EFAdaptationAlert *firstLoginZYDownloadAlert;
// 记录是否是第一次登录
@property (nonatomic, assign) BOOL userIsFirstLogin;
// --     ***      --

@property (nonatomic, strong) AFNetworkingManager *networkingManager;
@property (nonatomic, copy) dispatch_block_t downloadInitZipBlock;
@property (nonatomic, copy) dispatch_block_t downloadUpdateZipBlock;
@property (nonatomic, strong) NSURLSessionDownloadTask *initzipDownloadTask;
@property (nonatomic, strong) NSURLSessionDownloadTask *updatezipDownloadTask;

@end

@implementation EFLoginManager
@synthesize dComplete = _dComplete;
@synthesize downloadParam = _downloadParam;

#pragma mark - dealloc
- (void)dealloc {
    self.dComplete = nil;
    self.downloadParam = nil;
}

#pragma mark - lazy
// restful登录类
- (EFRestfulLoginOperation *)restfulLoginOperation {
    if (!_restfulLoginOperation) {
        _restfulLoginOperation = [[EFRestfulLoginOperation alloc] init];
    }
    return _restfulLoginOperation;
}

// 存放app版本信息的字典
- (NSMutableDictionary *)appVersionInfoDic {
    if (!_appVersionInfoDic) {
        _appVersionInfoDic = [[NSMutableDictionary alloc] init];
    }
    return _appVersionInfoDic;
}

// 网络请求
- (AFNetworkingManager *)networkingManager {
    if (!_networkingManager) {
        _networkingManager = [AFNetworkingManager new];
    }
    return _networkingManager;
}

// --  17年10月25日 --
// 首次登录加载资源文件的加载框
- (EFAdaptationAlert *)firstLoginZYDownloadAlert {
    if (!_firstLoginZYDownloadAlert) {
        _firstLoginZYDownloadAlert = [[EFAdaptationAlert alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                                        title:@"提示:"
                                                                     messages:@"正在更新资源文件..."
                                                             showProgressView:YES
                                                                     delegate:nil
                                                                          url:nil
                                                                   toFilePath:nil
                                                            cancelButtonTitle:@""
                                                            otherButtonTitles:@""];
    }
    return _firstLoginZYDownloadAlert;
}
// --     ***      --

#pragma mark - 首次登录
- (void)panLoginWithUserName:(NSString *)userName password:(NSString *)userPwd {
    _userIsFirstLogin = YES;
    [self.eventsViewController showHudView:@"正在登录..."];
    // 根据 OptionSetting.plist 中的 loginType 来选择 是 poro登录 还是 restful登录
    NSString *loginType = [ReadPlistFile readValueFromPlistName:@"OptionSetting.plist" valueKey:@"LoginType"];
        // 0 为 restful登录
        NSDictionary *serverDic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"OptionSetting.plist" ofType:nil]];
        NSString *APPID = [serverDic objectForKey:@"APPID"];
        NSDictionary *parametersDic = @{@"userId":userName, @"passWord":userPwd, @"appId":APPID, @"deviceType":@"iOS"};
        [self.restfulLoginOperation panRestfulLoginWithParametersDic:parametersDic success:^(NSDictionary *responseDic) {
            [self.eventsViewController hiddenHudView];
            if ([responseDic[@"result"] isEqualToString:@"success"]) {
                [self loginSuccess:responseDic];
            } else {
                //失败
                [self.eventsViewController showAlertViewWithTitle:@"" message:@"登录失败" tag:0 delegate:nil];
            }

        } fail:^(NSError *error) {
            [self.eventsViewController hiddenHudView];
            [self.eventsViewController showAlertViewWithTitle:@"" message:@"登录失败" tag:0 delegate:nil];
        }];
}

#pragma mark - restful首次登录
- (void)loginSuccess:(NSDictionary *)responseDic {
    NSNumber *idStr = [[responseDic objectForKey:@"user"] objectForKey:@"imUserId"];
    NSString *imuserid = [NSString stringWithFormat:@"%@",idStr];
    NSString *impassword = [[responseDic objectForKey:@"user"] objectForKey:@"imUserPassWord"];
    NSString *userName = [responseDic objectForKey:@"userName"];
    NSString *userId = [responseDic objectForKey:@"userId"];
    [EnvironmentVariable setUserName:userName];
    [EnvironmentVariable setUserID:userId];
    [EnvironmentVariable setIMUserID:imuserid];
    [EnvironmentVariable setIMPassword:impassword];
    
    // 得到版本信息
    [self restfulGetAppVersionInforWithInfoDic:responseDic];
    // 对比版本升级
    [self processInfoFirstWithViewController:self.eventsViewController];
}

#pragma mark - restful登录获取版本信息
- (void)restfulGetAppVersionInforWithInfoDic:(NSDictionary *)infoDic {
    //APP和资源文件最新信息
    NSDictionary *upgradeDic = [infoDic objectForKey:@"appUpgrade"];
    NSMutableDictionary *iosDic = [upgradeDic objectForKey:@"ios"];
    NSMutableDictionary *appInfo = [iosDic objectForKey:@"appFile"];
    NSMutableDictionary *resInfo = [iosDic objectForKey:@"appResource"];
    // APP最新版本号
    NSString *newestAppversion = [appInfo objectForKey:@"version"];
    // App更新信息
    NSString *appUpdateNote =  [appInfo objectForKey:@"des"];
    // App下载url
    NSString *url = [appInfo objectForKey:@"path"];
    // 资源文件最新版本号
    NSString *newestResVersion = [resInfo objectForKey:@"version"];
    // 资源文件更新信息
    NSString *resourceUpdateNote = [resInfo objectForKey:@"des"];
    NSString *resourceUpdatePath = resInfo[@"path"];
    
    // 提取信息
    [self recordAppVersionInfoWithNewAppVN:newestAppversion appUpdateNote:appUpdateNote resourceUpdateNote:resourceUpdateNote appUpdateUrl:url newResourceFileVersionNumber:newestResVersion resourceUpdatePath:resourceUpdatePath];
}

#pragma mark - 从登录成功之后返回的结果中提取app的版本信息
- (void)recordAppVersionInfoWithNewAppVN:(NSString *)newAppVersionNumber appUpdateNote:(NSString *)appUpdateNote  resourceUpdateNote:(NSString *)resourceUpdateNote appUpdateUrl:(NSString *)appUpdateUrl newResourceFileVersionNumber:(NSString *)newRFVersionNumber resourceUpdatePath:(NSString *)resourceUpdatePath {
    // 最新app版本号
    [self.appVersionInfoDic setObject:newAppVersionNumber ? newAppVersionNumber : @"" forKey:@"newAppVersionNumber"];
    // app更新信息
    [self.appVersionInfoDic setObject:appUpdateNote ? appUpdateNote : @"" forKey:@"APPUpdateNote"];
    // 资源包更新信息
    [self.appVersionInfoDic setObject:resourceUpdateNote ? resourceUpdateNote : @"" forKey:@"RESUpdateNote"];
    // app下载地址
    [self.appVersionInfoDic setObject:appUpdateUrl ? appUpdateUrl : @"" forKey:@"AppUpdateUrl"];
    // 最新资源包版本号
    [self.appVersionInfoDic setObject:newRFVersionNumber ? newRFVersionNumber : @"" forKey:@"newResourceFileVersionNumber"];
    // 最新资源包下载路径
    [self.appVersionInfoDic setObject:resourceUpdatePath ? resourceUpdatePath : @"" forKey:@"newResourceUpdatePath"];
}

#pragma mark -
- (void)processInfoFirstWithViewController:(UIViewController *)loginViewController {
    //判断pansoft升级
    //最新版本号
    NSString *newestVersion = self.appVersionInfoDic[@"newAppVersionNumber"];
    //当前版本号
//    if(updateStubObject){
        NSString *appbb = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSUserDefaults *ud =  [NSUserDefaults standardUserDefaults];
        [ud setObject:appbb forKey:@"currentVersion"];
        if(![appbb isEqualToString:newestVersion]){
            NSString *cancelTitle = [self isForcedToUpgradeWithLoaclVersion:appbb withNewVersion:newestVersion];
            //更新的信息
            NSString *message = [NSString stringWithFormat:@"%@%@", self.appVersionInfoDic[@"AppUpdateNote"] ? self.appVersionInfoDic[@"AppUpdateNote"] : @"", self.appVersionInfoDic[@"RESUpdateNote"] ? self.appVersionInfoDic[@"RESUpdateNote"] : @""];
            NSString *appUpdateUrl = self.appVersionInfoDic[@"AppUpdateUrl"];
            // 代理返回 升级地址
            if (_delegate != nil && [_delegate respondsToSelector:@selector(getAppUpdateUrl:)]) {
                [_delegate getAppUpdateUrl:appUpdateUrl];
            }
            NSString * filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            EFAdaptationAlert *alert = [[EFAdaptationAlert alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                                          title:@"提示: 系统应用升级"
                                                                       messages:message
                                                               showProgressView:NO
                                                                       delegate:loginViewController
                                                                            url:appUpdateUrl
                                                                     toFilePath:filePath
                                                              cancelButtonTitle:cancelTitle
                                                              otherButtonTitles:@"立即更新"];
            alert.delegate = self;
            alert.tag = 2000;
            if ([cancelTitle isEqualToString:@"取消"]) {
                alert.isCustomCancelButtonEvent = YES;
            }
            [loginViewController.view addSubview:alert];
            return;
        }
//    }
    // yes 是执行检测资源文件更新， no是不检测资源文件更新（提示了更新系统就不提示更新资源文件）
    [self continueToDoProcessInfoFirstViewController:loginViewController isUpdateVersion:YES];
}

- (void)continueToDoProcessInfoFirstViewController:(UIViewController *)loginViewController isUpdateVersion:(BOOL)isUpdateVersion {
    //获取当前版本号
    NSString *cVersion = [VersionUtil getCurrentVersion];
    //获取最新版本号
    NSString *uVersion = self.appVersionInfoDic[@"newResourceFileVersionNumber"];
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    BOOL isFirstLogin = NO;
    //判断是否用户第一次加载
    if([userDefs objectForKey:[[EnvironmentVariable getVersionPath] stringByAppendingString:@"_isFirst"]] == nil || [[userDefs objectForKey:[[EnvironmentVariable getVersionPath] stringByAppendingString:@"_isFirst"]] isEqualToString:@"1"])
        isFirstLogin = YES;
    //第一次加载，不提示直接下载资源文件/不是第一次的话根据版本号和isupdate确定接下来的操作
    //根据是否第一次进入程序 或 版本号信息加载资源
    if (isUpdateVersion) {
        if(isFirstLogin || ![cVersion isEqualToString:uVersion]) {
            NSMutableDictionary *verDic = [NSMutableDictionary dictionary];
            [verDic setObject:[NSNumber numberWithBool:isFirstLogin] forKey:isDownloadBaseVersion];
            [verDic setObject:uVersion forKey:isDownloadUpdateVersion];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [loginViewController hiddenHudView];
                [loginViewController.view addSubview:self.firstLoginZYDownloadAlert];
            });
            //进行下载  下载成功
            [self downloadFilesWithParam:verDic byViewController:loginViewController customEvent:NO];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_delegate != nil && [_delegate respondsToSelector:@selector(delegateCreateWebView)]) {
                    [_delegate delegateCreateWebView];
                }
            });
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_delegate != nil && [_delegate respondsToSelector:@selector(delegateCreateWebView)]) {
                [_delegate delegateCreateWebView];
            }
        });
    }
}

#pragma mark - 提示框中点击下载调用的方法
- (void)downloadFilesWithParam:(NSMutableDictionary *)verDic byViewController:(UIViewController *)loginVC customEvent:(BOOL)customEvent {
    [self downloadFilesWithParam:verDic complete:^(BOOL isSuccess, NSMutableDictionary *dataInfo){
        if (isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!customEvent) {
                    if (_delegate != nil && [_delegate respondsToSelector:@selector(delegateCreateWebView)]) {
                        [_delegate delegateCreateWebView];
                    }
                } else {
                    [FileUtil getPackageFiles];
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud setObject:@"YES" forKey:@"isUpdateRes"];
                    AppDelegate *newDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                    [newDelegate login];
                    [self.alert removeFromSuperview];
                    self.alert = nil;
                }
            });
        } else {
            if (!customEvent) {
                NSLog(@"%@",dataInfo);
                [loginVC hiddenHudView];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"下载资源文件出错，请检查网络" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [loginVC.view addSubview:self.firstLoginZYDownloadAlert];
                    [self downloadFilesWithParam:verDic byViewController:loginVC customEvent:customEvent];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:action];
                [alert addAction:cancelAction];
                [loginVC presentViewController:alert animated:YES completion:nil];
            } else {
                [_alert changeBtnTitle:@"重新下载" isHidden:NO];
            }
        }
    }];
}

#pragma mark - 自动登录
- (void)panLoginWithUserID:(NSString *)userID WithPassword:(NSString *)password IsCheck:(BOOL)isCheck {
    //    UIWindow *currentWindow =  [[UIApplication sharedApplication] keyWindow];
    NSString *networkStatus = [self getNetworkStatus];
    if ([networkStatus isEqualToString: @""]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HiddenChatLeftVCHUD object:self userInfo:nil];
        [self showHud:@"网络连接不可以用,请检查网络"];
        return;
    }
        // restful自动登录
        [self.restfulLoginOperation requestLoginServerSuccess:^(NSDictionary *responseDic) {
            [self.eventsViewController hiddenHudView];
            [self restfulAutomaticLoginWithResponseDic:responseDic passWord:password isCheck:isCheck];
        } fail:^(NSError * _Nonnull error) {
            [self.eventsViewController hiddenHudView];
            //登录失败，弹出框，跳到登录界面
            [[JFSocketManager sharedSocketManager] stopConnect];
            if (_delegate != nil && [_delegate respondsToSelector:@selector(whenAutomaticloginfailedTodDo)]) {
                [_delegate whenAutomaticloginfailedTodDo];
            }
        }];
}

#pragma mark - restful自动登录
- (void)restfulAutomaticLoginWithResponseDic:(NSDictionary *)responseDic passWord:(NSString *)passWord isCheck:(BOOL)isCheck {
    NSDictionary *resDic = responseDic;
    if ([[resDic objectForKey:@"result"] isEqualToString:@"success"]) {
        //成功
        //设置环境变量
        NSNumber *idStr = [[responseDic objectForKey:@"user"] objectForKey:@"imUserId"];
        NSString *imuserid = [NSString stringWithFormat:@"%@",idStr];
        NSString *impassword = [[responseDic objectForKey:@"user"] objectForKey:@"imUserPassWord"];
        NSString *userName = [[responseDic objectForKey:@"user"] objectForKey:@"userName"];
        NSString *userId = [[responseDic objectForKey:@"user"] objectForKey:@"userId"];
        [EnvironmentVariable setUserName:userName];
        [EnvironmentVariable setUserID:userId];
        [EnvironmentVariable setIMUserID:imuserid];
        [EnvironmentVariable setIMPassword:impassword];
        
        [EnvironmentVariable setPassWord:passWord];
        //发送上线信息
        EFMessageService *service = [EFMessageService sharedMessageService];
        [service connectManager];
        // 得到版本信息
        [self restfulGetAppVersionInforWithInfoDic:responseDic];
        // 对比版本信息 升级
        [self processInfoWithIsCheck:isCheck];
    } else {
        //失败
        //登录失败，弹出框，跳到登录界面
        if (_delegate != nil && [_delegate respondsToSelector:@selector(whenAutomaticloginfailedTodDo)]) {
            [_delegate whenAutomaticloginfailedTodDo];
        }
    }
}

- (void)processInfoWithIsCheck:(BOOL)isCheck {
    BOOL updateApp = NO;
    //最新版本号
    NSString *newestVersion = self.appVersionInfoDic[@"newAppVersionNumber"];
    //版本管理
    //获取资源文件当前版本号
    NSString *cVersion = [VersionUtil getCurrentVersion];
    //获取资源文件最新版本号
    NSString *uVersion = self.appVersionInfoDic[@"newResourceFileVersionNumber"];
    //判断当前版本
//    if(updateStubObject){
        NSString *appbb = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSUserDefaults *ud =  [NSUserDefaults standardUserDefaults];
        [ud setObject:appbb forKey:@"currentVersion"];
        if (isCheck) {
            [[NSNotificationCenter defaultCenter] postNotificationName:HiddenChatLeftVCHUD object:self userInfo:nil];
        }
        if (isCheck && [appbb isEqualToString:newestVersion] && [cVersion isEqualToString:uVersion]) {
            UIAlertView *altView = [[UIAlertView alloc] initWithTitle:@"" message:@"当前已是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [altView show];
        }
        if(![appbb isEqualToString:newestVersion]){
            NSString *cancelTitle = [self isForcedToUpgradeWithLoaclVersion:appbb withNewVersion:newestVersion];
            //更新的信息
            NSString *message = self.appVersionInfoDic[@"APPUpdateNote"];
            NSString *updateURL = self.appVersionInfoDic[@"AppUpdateUrl"];
            NSString * filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            EFAdaptationAlert *alert = [[EFAdaptationAlert alloc] initWithFrame:[UIScreen mainScreen].bounds title:@"提示: 系统应用升级" messages:message showProgressView:NO delegate:self url:updateURL toFilePath:filePath cancelButtonTitle:cancelTitle otherButtonTitles:@"立即更新"];
            updateApp = YES;
            [currentWindow addSubview: alert];
        }
//    }
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    BOOL isFirstLogin = NO;
    //判断是否用户第一次加载
    if([userDefs objectForKey:[[EnvironmentVariable getVersionPath] stringByAppendingString:@"_isFirst"]] == nil || [[userDefs objectForKey:[[EnvironmentVariable getVersionPath] stringByAppendingString:@"_isFirst"]] isEqualToString:@"1"]) {
        isFirstLogin = YES;
    }
    //根据是否第一次进入程序 或 版本号信息加载资源
    if(isFirstLogin || ![cVersion isEqualToString:uVersion]){
        NSMutableDictionary *verDic = [NSMutableDictionary dictionary];
        [verDic setObject:[NSNumber numberWithBool:isFirstLogin] forKey:isDownloadBaseVersion];
        [verDic setObject:uVersion forKey:isDownloadUpdateVersion];
        self.verDic = verDic;
        if (!updateApp) {
//            NSDictionary *updateMessage = updateStubObject.stubTable;
            NSString *message = self.appVersionInfoDic[@"RESUpdateNote"];
            [self showUpdateVersion:message];
        }
    }
}

#pragma mark - 检测网络状态
//判断连接网络状态
- (NSString *)getNetworkStatus {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NSString* netStatus = nil;
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status == NotReachable) {
        netStatus= @"";
    } else if (status == ReachableViaWiFi){
        netStatus=@"wifi";
    } else if (status == ReachableViaWWAN){
        netStatus=@"3g";
    }
    return netStatus;
}

#pragma mark - EFAdaptationAlertDelegate
- (void)showUpdateVersion:(NSString *)message {
    if (!_alert) {
        self.alert = [[EFAdaptationAlert alloc] initWithFrame:[UIScreen mainScreen].bounds title:@"更新" messages:message showProgressView:YES delegate:self url:@"" toFilePath:@"" cancelButtonTitle:@"取消" otherButtonTitles:@"立即下载"];
    }
    _alert.delegate = self;
    _alert.isCustomDownloadButtonEvent = YES;
    _alert.isCustomCancelButtonEvent = YES;
    [currentWindow addSubview:self.alert];
}

- (void)didClickButtonAtIndex:(NSInteger)index AlertView:(EFAdaptationAlert *)alertView {
    if (alertView.tag != 2000) {
        NSLog(@"下载资源文件");
        [alertView changeBtnTitle:@"" isHidden:YES];
        [self downloadFilesWithParam:self.verDic byViewController:nil customEvent:YES];
    }
}

- (void)didClickCancelButton:(EFAdaptationAlert *)alertView {
    __weak typeof(self) weakSelf = self;
//    [queue cancelAllOperations];
    [self cancelDownload];
    [UIView animateWithDuration:0.3 animations:^{
        alertView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (alertView.tag == 2000) {
            [alertView removeFromSuperview];
            weakSelf.alert = nil;
            [self continueToDoProcessInfoFirstViewController:self.eventsViewController isUpdateVersion:NO];
        } else {
            [alertView removeFromSuperview];
            weakSelf.alert = nil;
        }
    }];
}

#pragma mark - HB提示框
- (void)showHud:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:currentWindow animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

#pragma mark - 下载资源文件
- (void)downloadFilesWithParam:(NSMutableDictionary *)param complete:(downloadComplete)complete {
//    // 初始化Documents路径
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    downloadPath = path;
//    // 拿到appid，在appdelegate中有赋值的地方
//    JParamObject *po = [JParamObject Create];
//    NSString *APPID = [po getEnvForKey:@"APPID" defaultValue:nil];
//    // 创建restful方式中，下载 init.zip 与 updata.zip 的路径的数组
//    NSArray *pathArray = [[NSArray alloc] init];
//    if (self.appVersionInfoDic[@"newResourceUpdatePath"] && ![self.appVersionInfoDic[@"newResourceUpdatePath"] isEqualToString:@""]) {
//        // restful 下载路径 存放 init.zip 与 updata.zip 中间用 ; 分割
//        pathArray = [self.appVersionInfoDic[@"newResourceUpdatePath"] componentsSeparatedByString:@";"];
//    }
//    // 下载资源文件的路径 (po ro方式用到)
//    NSString *resourceFilePath = @"/MobileResource/";//[param objectForKey:@"update"];
//    resourceFilePath = [resourceFilePath stringByAppendingString:APPID];
//
//    // 下载队列
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_queue_t queue = dispatch_queue_create("download", DISPATCH_QUEUE_SERIAL);
//    __weak typeof(self) weakSelf = self;
//    // 1.需要下载基础资源包
//    if ([param objectForKey:isDownloadBaseVersion]) {
//        // 组装下载路径
//        NSString *initPath = [resourceFilePath stringByAppendingString:@"/init.zip"];
//        NSString *urlString = @"";
//        if (pathArray.count > 0) {
//            // 如果是 restful方式，路径就读取restful方式的
//            urlString = [pathArray firstObject];
//        } else {
//            // po ro方式
//            urlString = [URLUtil getUrlWithPath:initPath];
//        }
//        // 创建下载任务
//        _downloadInitZipBlock = dispatch_block_create(0, ^{
//           _initzipDownloadTask = [self.networkingManager netWorkingDownLoadWithUrl:urlString parameters:nil localPath:[NSURL fileURLWithPath:path] progress:^(NSProgress *progress) {
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    CGFloat percent = progress.fractionCompleted;
//                    NSInteger total = progress.totalUnitCount;
//                    [weakSelf updateProgerssWithPercent:percent total:total title:@"正在下载基础资源包"];
//                });
//            } success:^(id result) {
//                NSDictionary *resultDic = (NSDictionary *)result;
//                NSString *filePathString = resultDic[@"filePath"];
//                NSString *baseVerName = [[filePathString componentsSeparatedByString:@"/"] lastObject];
//                [param setObject:baseVerName forKey:kBaseVersionName];
//                NSLog(@"init.zip download finished");
//            } failure:^(NSString *error) {
//                NSLog(@"init.zip download failed");
//            }];
//        });
//        dispatch_group_async(group, queue, _downloadInitZipBlock);
//    }
//    // 2.需要现在更新资源包
//    if ([param objectForKey:isDownloadUpdateVersion]) {
//        NSString *updatePath = [resourceFilePath stringByAppendingString:@"/update.zip"];
//        NSString *urlString = @"";
//        if (pathArray.count > 0) {
//            // 如果是 restful方式，路径就读取restful方式的
//            urlString = [pathArray lastObject];
//        } else {
//            // po ro 方式的
//            urlString = [URLUtil getUrlWithPath:updatePath];
//        }
//        // 创建下载任务
//        _downloadUpdateZipBlock = dispatch_block_create(0, ^{
//            _updatezipDownloadTask = [weakSelf.networkingManager netWorkingDownLoadWithUrl:urlString parameters:nil localPath:[NSURL fileURLWithPath:path] progress:^(NSProgress *progress) {
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    CGFloat percent = progress.fractionCompleted;
//                    NSInteger total = progress.totalUnitCount;
//                    [weakSelf updateProgerssWithPercent:percent total:total title:@"正在下载资源包"];
//                });
//            } success:^(id result) {
//                NSDictionary *resultDic = (NSDictionary *)result;
//                NSString *filePathString = resultDic[@"filePath"];
//                NSString *updateVerResName = [[filePathString componentsSeparatedByString:@"/"] lastObject];
//                [param setObject:updateVerResName forKey:kUpdateVersionName];
//                NSLog(@"update.zip download finished");
//                // 解压文件
//                [weakSelf downloadFinishedUnZip];
//            } failure:^(NSString *error) {
//                NSLog(@"update.zip download failed");
//            }];
//        });
//        dispatch_group_async(group, queue, _downloadUpdateZipBlock);
//    }
//    // 记录param ， 解压的时候用到
//    self.downloadParam = param;
//    self.dComplete = complete;
}

#pragma mark - 取消下载
- (void)cancelDownload {
//    // 取消下载
//    [self.networkingManager cancelDownloadTaskWithTask:_initzipDownloadTask];
//    [self.networkingManager cancelDownloadTaskWithTask:_updatezipDownloadTask];
//    // 取消CGD
//    if (_downloadInitZipBlock) {
//        dispatch_block_cancel(_downloadInitZipBlock);
//    }
//    if (_downloadUpdateZipBlock) {
//        dispatch_block_cancel(_downloadUpdateZipBlock);
//    }
}

#pragma mark - 下载资源文件的过程中更新UI
- (void)updateProgerssWithPercent:(CGFloat)percent total:(NSInteger)total title:(NSString *)title {
    // 检查更新的时候的提示框
    self.alert.progressV.progress = percent;
    self.alert.progressLable.text = [NSString stringWithFormat:@"%.f%%", percent * 100];
    self.alert.promptLabel.text = title; //@"正在下载资源包";
    if (total / 1024 > 1024) {
        self.alert.promptLabel.text = [NSString stringWithFormat:@"%@(总共%ldMB)", self.alert.promptLabel.text, total / 1024 / 1024];
    } else {
        self.alert.promptLabel.text = [NSString stringWithFormat:@"%@(总共%ldKB)", self.alert.promptLabel.text, total / 1024];
    }
    // 首次登录的提示框
    if (_userIsFirstLogin) {
        _firstLoginZYDownloadAlert.progressV.progress = percent;
        _firstLoginZYDownloadAlert.progressLable.text = [NSString stringWithFormat:@"%.f%%", percent * 100];
    }
}

#pragma mark - 下载完成之后解压操作
- (void)downloadFinishedUnZip {
    if ([self unzipResourceFiles]) {
        if ([_downloadParam objectForKey:isDownloadBaseVersion])
            [self changeFirstLoginTo:NO];
        if ([_downloadParam objectForKey:isDownloadUpdateVersion])
            [self changeLocalResVersion:[_downloadParam objectForKey:isDownloadUpdateVersion]];
        self.downloadParam = nil;
        self.dComplete = nil;
    }
}

#pragma mark - 解压文件
- (BOOL)unzipResourceFiles {
    BOOL allSuccess = NO;
    BOOL needUnzip  = NO;
    // 解压成功 基础包
    BOOL baseZip = NO;
    // 解压成功 资源文件包
    BOOL updateZip = NO;
    NSMutableDictionary *resDataInfo = [NSMutableDictionary dictionary];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    ZipArchive *unzip = [[ZipArchive alloc] init];
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/"];
    NSString *unzipPath = path;//[path stringByAppendingPathComponent:@"res/"];
    // 解压 res_0.0.0.zip
    if ([_downloadParam objectForKey:kBaseVersionName] != nil) {
        needUnzip = YES;
        NSString *res_base = [path stringByAppendingPathComponent:[_downloadParam objectForKey:kBaseVersionName]];
        if ([unzip UnzipOpenFile:res_base]) {
            NSString *path1 = [unzipPath stringByAppendingString:[EnvironmentVariable getVersionPath]];
            allSuccess = [unzip UnzipFileTo:path1  overWrite:YES];
            [unzip UnzipCloseFile];
            
            // 解压失败
            if (!allSuccess) {
                [resDataInfo setObject:@"解压失败" forKey:@"ERROR"];
                if (_dComplete != nil) {
                    _dComplete(allSuccess, resDataInfo);
                    self.dComplete = nil;
                    return NO;
                }
            } else {
                baseZip = YES;
            }
            //删掉下载文件
            [fileMgr removeItemAtPath:res_base error:nil];
        }
    } else {
        
    }
    
    if ([_downloadParam objectForKey:kUpdateVersionName] != nil) {
        needUnzip = YES;
        // 解压 res_[update].zip
        NSString *res_update = [path stringByAppendingPathComponent:[_downloadParam objectForKey:kUpdateVersionName]];
        if ([unzip UnzipOpenFile:res_update]) {
            allSuccess = [unzip UnzipFileTo:[unzipPath stringByAppendingString:[EnvironmentVariable getVersionPath]] overWrite:YES];
            [unzip UnzipCloseFile];
            
            // 解压失败
            if (!allSuccess) {
                [resDataInfo setObject:@"解压失败" forKey:@"ERROR"];
                if (_dComplete != nil) {
                    _dComplete(allSuccess, resDataInfo);
                    self.dComplete = nil;
                    return NO;
                }
            } else {
                updateZip = YES;
            }
            //删掉下载文件
            [fileMgr removeItemAtPath:res_update error:nil];
        } else {
            allSuccess = NO;
        }
    } else {
        
    }
    
    if (needUnzip) {
        //        [FileUtil getPackageFiles];
    }
    
    if (baseZip && updateZip) {
        _dComplete(allSuccess, resDataInfo);
        self.dComplete = nil;
        return YES;
    } else {
        _dComplete(allSuccess, resDataInfo);
        return NO;
    }
    return NO;
}

- (void)changeFirstLoginTo:(BOOL)isFirst {
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    NSString *isFirstString = isFirst ? @"1" : @"0";
    [userDefs setObject:isFirstString forKey:[[EnvironmentVariable getVersionPath] stringByAppendingString:@"_isFirst"]];
    [userDefs synchronize];
}

- (void)changeLocalResVersion:(NSString *)version {
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setObject:version forKey:[[EnvironmentVariable getVersionPath] stringByAppendingString:@"_currentVersion"]];
    [userDefs synchronize];
}

/// 获取用户会议文件目录
+ (NSString *)meetingFileDirectoryForUser:(NSString *)userID {
    NSString *localResourcePath = [self localRecourceDirectory];
    NSString *localUserPath     = [localResourcePath stringByAppendingPathComponent:userID];
    NSString *meetingDirectory  = [localUserPath stringByAppendingPathComponent:@"meetingSystem"];
    return meetingDirectory;
}

/// 获取本地LOCAL_RESOURCE目录
+ (NSString *)localRecourceDirectory {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *docMainPath = [docPath stringByAppendingPathComponent:kLocalResource];
    return docMainPath;
}

///获取Plist配置信息
+ (NSDictionary *)getPlistDic:(NSString *)plistName {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *docMainPath = [docPath stringByAppendingPathComponent:kLocalResource];
    NSString *filedirPath = [docMainPath stringByAppendingPathComponent:kPlisteDirectory];
    NSString *filePath = [filedirPath stringByAppendingPathComponent:plistName];
    NSDictionary *data = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    
    return data;
}


///更新Plist配置信息
+ (void)updatePlistDic:(NSMutableDictionary *)aDataInfo plistName:(NSString *)plistName {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *docMainPath = [docPath stringByAppendingPathComponent:kLocalResource];
    NSString *filedirPath = [docMainPath stringByAppendingPathComponent:kPlisteDirectory];
    NSString *filePath = [filedirPath stringByAppendingPathComponent:plistName];
    
    [aDataInfo writeToFile:filePath atomically:YES];
}

// 拷贝文件
+ (void)copyOptionSettingFileToDocument:(NSArray *)fileList {
    [self doCreateFileDirectory];
    NSFileManager *fileMng = [NSFileManager defaultManager];
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *docMainPath = [docPath stringByAppendingPathComponent:kLocalResource];
    NSString *filedirPath = [docMainPath stringByAppendingPathComponent:kPlisteDirectory];
    for(NSString *file in fileList) {
        NSString *fileToPath = [filedirPath stringByAppendingPathComponent:file];
        NSString *filePath = [[NSBundle mainBundle]pathForResource:[[file componentsSeparatedByString:@"."] firstObject] ofType:@"plist"];
        BOOL isDirectory = YES;
        if (![fileMng fileExistsAtPath:fileToPath isDirectory:&isDirectory]) {
            // 创建目录
            BOOL isSuccessCopy = [fileMng copyItemAtPath:filePath toPath:fileToPath error:nil];
            if (!isSuccessCopy) {
                NSLog(@"= ERROR : create path:%@ failed = %s(line:%d) ==>", filePath, __func__,__LINE__);
            }
        }
    }
}

/// 创建文件目录
+ (void)doCreateFileDirectory {
    NSFileManager *fileMng = [NSFileManager defaultManager];
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    // 文件主目录(存储server下载zip及解压后的文件)
    NSString *docMainPath = [docPath stringByAppendingPathComponent:kServerResource];
    BOOL isSuccess = [fileMng createDirectoryAtPath:docMainPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (!isSuccess) {
        NSLog(@"= ERROR : create path:%@ failed = %s(line:%d) ==>", docMainPath, __func__,__LINE__);
    }
    
    // 文件主目录(存储本地用文件：plist、sqlite)
    // 1. PLISTE
    NSString *localResPath = [docPath stringByAppendingPathComponent:kLocalResource];
    NSString *plistPath = [localResPath stringByAppendingPathComponent:kPlisteDirectory];
    isSuccess = [fileMng createDirectoryAtPath:plistPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (!isSuccess) {
        NSLog(@"= ERROR : create path:%@ failed = %s(line:%d) ==>", plistPath, __func__,__LINE__);
    }
}

- (NSString *)isForcedToUpgradeWithLoaclVersion:(NSString *)localVersion withNewVersion:(NSString *)newVersion {
    NSString *cancelTitle;
    NSArray *localVersionArray = [localVersion componentsSeparatedByString:@"."];
    NSArray *newVersionArray = [newVersion componentsSeparatedByString:@"."];
    if ([newVersionArray[0] integerValue] > [localVersionArray[0] integerValue]|| [newVersionArray[1] integerValue] > [localVersionArray[1] integerValue]) {
        //强制升级
        cancelTitle = @"强制升级";
    }else if ([newVersionArray[2] integerValue] > [localVersionArray[2] integerValue]){
        //非强制升级
        cancelTitle = @"取消";
    }
    return cancelTitle;
}

@end

