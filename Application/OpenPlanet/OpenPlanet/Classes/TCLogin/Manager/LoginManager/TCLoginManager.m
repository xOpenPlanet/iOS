//
//  TCLoginManager.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/12.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCLoginManager.h"
#import "AFNetworking.h"
#import "TokenRequestManager.h"

@implementation TCLoginManager

#pragma mark - 检查是新用户还是老用户(通过手机号)
+ (void)checkIsOldUserWithPhone:(NSString *)phone
                        success:(SuccessBlock)success
                           fail:(FailBlock)fail{
    NSString *urlString = [NSString stringWithFormat:@"%@/tcserver/user/login?phoneNumber=%@",TCUrl,SafeString(phone)];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8));
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:encodeStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(responseObject);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (fail) {
                fail(error.localizedDescription);
            }
        });
    }];
}


#pragma mark - 获取验证码
+ (void)getSMSWithPhone:(NSString *)phone
                success:(SuccessBlock)success
                   fail:(FailBlock)fail{
    NSString *urlString = [NSString stringWithFormat:@"%@/tcserver/user/sendVerifyCode2mobilePhone?phoneNumber=%@",TCUrl,SafeString(phone)];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8));
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:encodeStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(responseObject);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (fail) {
                fail(error.localizedDescription);
            }
        });
    }];
}


#pragma mark - 校验验证码
+ (void)checkSMSWithPhone:(NSString *)phone
                     code:(NSString *)code
                  success:(SuccessBlock)success
                     fail:(FailBlock)fail{
    NSString *urlString = [NSString stringWithFormat:@"%@/tcserver/user/verifyPhoneCode?phoneNumber=%@&code=%@",TCUrl,SafeString(phone),SafeString(code)];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8));
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:encodeStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(responseObject);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (fail) {
                fail(error.localizedDescription);
            }
        });
    }];
}



#pragma mark - 注册新用户
+ (void)registerNewUserWithPhone:(NSString *)phone
                        nickName:(NSString *)nickName
                        password:(NSString *)password
                      inviteCode:(NSString *)inviteCode
                    planetEnName:(NSString *)planetEnName
                         success:(SuccessBlock)success
                            fail:(FailBlock)fail{
    NSString *urlString = [NSString stringWithFormat:@"%@/tcserver/user/register?phoneNumber=%@&userName=%@&password=%@&inviteCode=%@&planet=%@",TCUrl,SafeString(phone),SafeString(nickName),SafeString(password),SafeString(inviteCode),SafeString(planetEnName)];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8));
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:encodeStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(responseObject);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (fail) {
                fail(error.localizedDescription);
            }
        });
    }];
}



#pragma mark - 登录
+ (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
               success:(SuccessBlock)success
                  fail:(FailBlock)fail{
    
    NSDictionary *params = @{
                             @"grant_type":@"password",
                             @"passwordType":@"password",
                             @"username":SafeString(phone),
                             @"password":SafeString(password)
                             };
    
    [TokenRequestManager tokenRequestWithType:TokenRequestTypeLogin changeParams:params success:^(id result) {
        if (success) {
            success(result);
        }
    } fail:^(NSString *errorDescription) {
        if (fail) {
            fail(errorDescription);
        }
    }];
}

#pragma mark - 验证码登录
+ (void)SMSLoginWithPhone:(NSString *)phone
                  smsCode:(NSString *)smsCode
                  success:(SuccessBlock)success
                     fail:(FailBlock)fail{
    NSDictionary *params = @{
                             @"grant_type":@"password",
                             @"passwordType":@"smsCode",
                             @"username":SafeString(phone),
                             @"password":SafeString(smsCode)
                             };
    [TokenRequestManager tokenRequestWithType:TokenRequestTypeSMSLogin changeParams:params success:^(id result) {
        if (success) {
            success(result);
        }
    } fail:^(NSString *errorDescription) {
        if (fail) {
            fail(errorDescription);
        }
    }];
}

#pragma mark - 获取用户信息
+ (void)getUserInfoWithSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    NSString *token = [TokenRequestManager access_token];
    NSString *urlString = [NSString stringWithFormat:@"%@/tcserver/oauth/userInfo?access_token=%@",TCUrl,SafeString(token)];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8));
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:encodeStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TokenRequestManager isTokenExpiredWithResponse:responseObject complete:^(BOOL isTokenExpired){
                if (isTokenExpired) {
                    [self getUserInfoWithSuccess:success fail:fail];
                }else{
                    if (success) {
                        success(responseObject);
                    }
                }
            }];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(fail){
                fail(error.localizedDescription);
            }
        });
    }];
}




#pragma mark - 上传通讯录
+ (void)uploadFansWithFans:(NSArray *)peoples progress:(FloatBlock)progress success:(SuccessBlock)success fail:(FailBlock)fail{
    NSString *token = [TokenRequestManager access_token];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/tcserver/linkMan/upLoadLinkMans",TCUrl];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8));
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *jsonString =  [NSString jsonInfoToJsonString:@{@"linkMans":peoples}];
    NSDictionary *params = @{
                             @"access_token":token,
                             @"linkMans":jsonString
                             };
    
    [manager POST:encodeStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat pro= 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        dispatch_async(dispatch_get_main_queue(), ^{
            progress(pro);
        });
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TokenRequestManager isTokenExpiredWithResponse:responseObject complete:^(BOOL isTokenExpired){
                if (isTokenExpired) {
                    [self uploadFansWithFans:peoples progress:progress success:success fail:fail];
                }else{
                    if (success) {
                        success(responseObject);
                    }
                }
            }];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(fail){
                fail(error.localizedDescription);
            }
        });
    }];
}

#pragma mark - 获取通讯录
+ (void)loadPeopleWithSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    NSString *token = [TokenRequestManager access_token];
    NSString *urlString = [NSString stringWithFormat:@"%@/tcserver/linkMan/getLinkMans?access_token=%@",TCUrl,token];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8));
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:encodeStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TokenRequestManager isTokenExpiredWithResponse:responseObject complete:^(BOOL isTokenExpired){
                if (isTokenExpired) {
                    [self loadPeopleWithSuccess:success fail:fail];
                }else{
                    if (success) {
                        success(responseObject);
                    }
                }
            }];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(fail){
                fail(error.localizedDescription);
            }
        });
    }];
}


#pragma mark - 保存钱包公钥和钱包地址
+ (void)saveWalletWithWalletAddress:(NSString *)walletAddress publicKey:(NSString *)publicKey comPublicKey:(NSString *)comPublicKey success:(SuccessBlock)success fail:(FailBlock)fail{
    NSString *token = [TokenRequestManager access_token];
    NSString *urlString = [NSString stringWithFormat:@"%@/tcserver/user/updateUserEthPublicKeyAndAddress",TCUrl];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8));
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{
                             @"access_token":token,
                             @"ethAddress":walletAddress,
                             @"ethPublicKey":publicKey,
                             @"comPublicKey":comPublicKey
                             };
    [manager POST:encodeStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TokenRequestManager isTokenExpiredWithResponse:responseObject complete:^(BOOL isTokenExpired){
                if (isTokenExpired) {
                    [self saveWalletWithWalletAddress:walletAddress publicKey:publicKey comPublicKey:comPublicKey success:success fail:false];
                }else{
                    if (success) {
                        success(responseObject);
                    }
                }
            }];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(fail){
                fail(error.localizedDescription);
            }
        });
    }];
}

#pragma mark - 更新通讯公钥
+ (void)updateComPublicKey:(NSString *)comPublicKey success:(SuccessBlock)success fail:(FailBlock)fail{
    NSString *token = [TokenRequestManager access_token];
    NSString *urlString = [NSString stringWithFormat:@"%@/tcserver/user/updateUserComPublicKey",TCUrl];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8));
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{
                             @"access_token":token,
                             @"comPublicKey":comPublicKey,
                             };
    [manager POST:encodeStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TokenRequestManager isTokenExpiredWithResponse:responseObject complete:^(BOOL isTokenExpired){
                if (isTokenExpired) {
                    [self updateComPublicKey:comPublicKey success:success fail:false];
                }else{
                    if (success) {
                        success(responseObject);
                    }
                }
            }];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (fail) {
                fail(error.localizedDescription);
            }
        });
    }];
}

#pragma mark - 校验邀请码
+(void)checkInviteCodeWithInviteCode:(NSString *)inviteCode success:(SuccessBlock)success fail:(FailBlock)fail{
    NSString *urlString = [NSString stringWithFormat:@"%@/tcserver/user/verifyInviteCodeAvailabilityCount?inviteCode=%@",TCUrl,inviteCode];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8));
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:encodeStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(responseObject);
            }
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(fail){
                fail(error.localizedDescription);
            }
        });
    }];
    
}

@end
