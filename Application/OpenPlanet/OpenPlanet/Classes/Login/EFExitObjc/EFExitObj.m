//
//  EFExitObj.m
//  OSPMobile
//
//  Created by 于仁汇 on 2017/7/6.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import "EFExitObj.h"
#import "EFRestfullExitObj.h"
#import "ReadPlistFile.h"
#import "EnvironmentVariable.h"
#import "JFMessageManager.h"

@interface EFExitObj ()<JFSocketManagerDelegate, JFMessageManagerDelegate>

@property (nonatomic, strong) EFRestfullExitObj *restfullExitObj;
@property (nonatomic, copy) exitSuccessCompletionHandle success;
@property (nonatomic, copy) exitFailCompletionHandle fail;

@end

@implementation EFExitObj

#pragma mark - 退出
- (void)exitObjSuccess:(exitSuccessCompletionHandle)success fail:(exitFailCompletionHandle)fail {
    // 断开连接
    [[JFMessageManager sharedMessageManager] addMessageDelegate:self];
    [[JFSocketManager sharedSocketManager] stopConnect];
    
    self.success = success;
    self.fail = fail;
}

#pragma mark - 删除基本数据并退出
- (void)exitOperationAndRemoveSomeParameterSuccess:(exitSuccessCompletionHandle)success fail:(exitFailCompletionHandle)fail {
    self.success = success;
    self.fail = fail;
    [self exitOperationAndRemoveSomeParameter];
}

#pragma mark - 断开连接代理
- (void)onMessageManagerDidDisConnect:(JFMessageManager *)messageManager {
    [self exitOperationAndRemoveSomeParameter];
}

- (void)exitOperationAndRemoveSomeParameter {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
    [EnvironmentVariable setUnPersistenceProperty:@"" forKey:@"newFriendBadgeValue"];
    [EnvironmentVariable setUnPersistenceProperty:@"" forKey:@"newJoinGroupBadgeValue"];
    NSString *userId = [EnvironmentVariable getIMUserID];
    NSString *passWord = [EnvironmentVariable getIMPassword];
    NSString *token = [EnvironmentVariable getDeviceToken];
    NSString *deviceId = [EnvironmentVariable getPropertyForKey:@"UUID" WithDefaultValue:@""];
    [[NSUserDefaults standardUserDefaults] setObject:@"AUTONO" forKey:@"isAutoLogin"];
    // 执行 退出
    [self exitOperationWithUserId:userId passWord:passWord token:token deviceId:deviceId];
}


#pragma mark - 选择退出的方式
- (void)exitOperationWithUserId:(NSString *)userId passWord:(NSString *)passWord token:(NSString *)token deviceId:(NSString *)deviceId {
    // restfull 退出
    [self.restfullExitObj restfullExitWithUserId:userId passWord:passWord token:token deviceId:deviceId success:^(NSDictionary *responseDic) {
        if ([responseDic[@"result"] isEqualToString:@"success"]) {
            self.success(responseDic);
        } else {
            self.fail(responseDic[@"msg"] ? responseDic[@"msg"] : @"退出失败");
        }
    } fail:^(NSString *error) {
        self.fail(error ? error : @"退出失败");
    }];
}


#pragma mark - lazy
- (EFRestfullExitObj * )restfullExitObj {
    if (!_restfullExitObj) {
        _restfullExitObj = [[EFRestfullExitObj alloc] init];
    }
    return _restfullExitObj;
}

@end
