//
//  EFRestfulLoginOperation.m
//  OSPMobile
//
//  Created by 于仁汇 on 2017/9/19.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import "EFRestfulLoginOperation.h"
#import "EnvironmentVariable.h"
#import "AFHTTPSessionManager.h"
#import "EAI.h"

@interface EFRestfulLoginOperation ()

@end

@implementation EFRestfulLoginOperation

#pragma mark - 首次登录
- (void)panRestfulLoginWithParametersDic:(NSDictionary *)parametersDic success:(RestfulSuccessCompletionHandle)successCompletionHandle fail:(RestfulFailCompletionHandle)failCompletionHandle {
    // 存储登录参数
    [EnvironmentVariable setProperty:parametersDic forKey:@"JsonLoginParameters"];
    //使用多线程,发出登录请求
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime,dispatch_get_global_queue(0, 0), ^{
        //增加资源配置
        NSString *ip = [EAI getServer];
        NSString *port = [EAI getPort];
        NSString *server = [EAI getPath];
        NSString *APPID = [EnvironmentVariable getPropertyForKey:@"APPID" WithDefaultValue:nil];
        //服务器标识区分资源文件
        NSString *versionPath = [[[ip stringByAppendingString:port] stringByAppendingString:server] stringByAppendingString:APPID];
        [EnvironmentVariable setVersionPath:versionPath];
        
        //登录操作
        [self requestLoginServerSuccess:^(NSDictionary *responseDic) {
            successCompletionHandle(responseDic);
        } fail:^(NSError * _Nonnull error) {
            failCompletionHandle(error);
        }];
    });
}

#pragma mark - 登录
- (void)requestLoginServerSuccess:(LoginSuccessCompletionHandle)success fail:(LoginFailCompletionHandle)fail {
    //登录操作
    NSDictionary *parametersDic = [EnvironmentVariable getPropertyForKey:@"JsonLoginParameters" WithDefaultValue:@""];
    // 创建请求地址
    NSString *optionPath = [[NSBundle mainBundle] pathForResource:@"OptionSetting.plist" ofType:nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:optionPath];
    NSString *restfulInterface = [dic objectForKey:@"RestfulInterface"];
    // 参数
    NSMutableString *parametesStr = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i <= [parametersDic allKeys].count - 1; i++) {
        NSString *key = [parametersDic allKeys][i];
        [parametesStr appendString:[NSString stringWithFormat:@"%@=%@", key, parametersDic[key]]];
        if (i < [parametersDic allKeys].count - 1) {
            [parametesStr appendString:@"&"];
        }
        
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/login?%@", restfulInterface, parametesStr];
    NSLog(@"%@", urlStr);
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
              //失败
              fail(error);
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
