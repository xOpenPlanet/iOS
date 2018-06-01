//
//  EFLoginManager.h
//  OSPMobile
//
//  Created by 虎 谢 on 16/12/4.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "Constant.h"

typedef void (^ loginCheckComplete)(BOOL legal, NSMutableDictionary *dataInfo);
typedef void (^ downloadComplete)(BOOL isSuccess, NSMutableDictionary *dataInfo);

@protocol EFLoginManagerDelegate <NSObject>

@optional
- (void)whenAutomaticloginfailedTodDo;

/// 登录成功后 获得 responseMap
- (void)getLoginResponseMap:(NSDictionary*)mapDict;
/// 登录成功后 获得 app更新的地址
- (void)getAppUpdateUrl:(NSString *)updateUrl;
/// 创建webView
- (void)delegateCreateWebView;

@end

@interface EFLoginManager : NSObject
{
    float                   fileLength;
    NSString                *downloadPath;
}

@property (nonatomic, copy) NSString *serverURL;
@property (nonatomic, weak) id<EFLoginManagerDelegate> delegate;
/// 发生登录事件的 viewcontroller
@property (nonatomic, strong) UIViewController *eventsViewController;

//第一次登录
- (void)panLoginWithUserName:(NSString *)userName password:(NSString *)userPwd;

///自动登录
- (void)panLoginWithUserID:(NSString *)userID WithPassword:(NSString *)password IsCheck:(BOOL)isCheck;

///下载文件
- (void)downloadFilesWithParam:(NSMutableDictionary *)param complete:(downloadComplete)complete;

+ (NSDictionary *)getPlistDic:(NSString *)plistName;

+ (void)updatePlistDic:(NSMutableDictionary *)aDataInfo plistName:(NSString *)plistName ;

+ (void)copyOptionSettingFileToDocument:(NSArray *)fileList;

@end
