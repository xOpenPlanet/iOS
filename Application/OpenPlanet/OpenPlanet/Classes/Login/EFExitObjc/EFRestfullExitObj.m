//
//  EFRestfullLExitObj.m
//  OSPMobile
//
//  Created by 于仁汇 on 2017/7/5.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import "EFRestfullExitObj.h"
#import "AFNetworking.h"
#import "ReadPlistFile.h"

@interface EFRestfullExitObj ()<JFSocketManagerDelegate, JFMessageManagerDelegate>

@end

@implementation EFRestfullExitObj

- (void)restfullExitWithUserId:(NSString *)userId passWord:(NSString *)passWord token:(NSString *)token deviceId:(NSString *)deviceId success:(restfullExitSuccessCompletionHandle)success fail:(restfullExitFailCompletionHandle)fail {
    NSString *IMServer = [ReadPlistFile readValueFromPlistName:@"OptionSetting.plist" valueKey:@"IMBaseUrl"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/IMServer/user/logout?userId=%@&passWord=%@&deviceId=%@&token=%@", IMServer, userId, passWord, deviceId, token];
    [self netWorkingWithUrl:urlStr success:^(NSDictionary *responseDic) {
        if ([responseDic[@"result"] isEqualToString:@"success"]) {
            success(responseDic);
        } else {
            fail(responseDic[@"msg"] ? responseDic[@"msg"] : @"退出失败");
        }
    } fail:^(NSString *error) {
        fail(error ? error : @"退出失败");
    }];
}

// 网络请求
- (void)netWorkingWithUrl:(NSString *)urlStr success:(restfullExitSuccessCompletionHandle)success fail:(restfullExitFailCompletionHandle)fail {
    // AF网络请求
    AFHTTPSessionManager *afManager = [AFHTTPSessionManager manager];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlStr, NULL, NULL, kCFStringEncodingUTF8));
    afManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self deleteCookie];
    // GET
    [afManager GET:encodeStr
        parameters:nil
          progress:^(NSProgress * _Nonnull downloadProgress) {
          } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSLog(@"GET -- %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
              NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              success(responseDic);
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"GET -- %@", error.localizedDescription);
              fail(error.localizedDescription);
          }];

}

#pragma mark - 清除cookie
- (void)deleteCookie {
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in cookieArray) {
        [cookieJar deleteCookie:obj];
    }
}


@end
