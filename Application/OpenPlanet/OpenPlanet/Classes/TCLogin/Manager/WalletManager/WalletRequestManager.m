//
//  WalletRequestManager.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/20.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "WalletRequestManager.h"
#import "AFNetworking.h"
#import "Constant.h"
#import "TokenRequestManager.h"

@implementation WalletRequestManager

#pragma mark - 查询余额
+ (void)queryBalanceWithAddress:(NSString *)address success:(SuccessBlock)success fail:(FailBlock)fail{
    NSString *urlString = [NSString stringWithFormat:@"%@/tcserver/eth/ethGetBalance?ethAddress=%@",TCUrl,address];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8));
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:encodeStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            success(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            fail(error.localizedDescription);
        });
    }];
}

#pragma mark - 请求多钱包账户余额
+ (void)queryBalancesWithAddresses:(NSArray<NSString *> *)addresses success:(SuccessBlock)success fail:(FailBlock)fail{
    
    NSString *addressString = [NSString string];
    for (NSString *address in addresses) {
        addressString = [addressString stringByAppendingString:address];
        addressString = [addressString stringByAppendingString:@";"];
    }
    if (addresses.count > 0) {
        addressString = [addressString substringToIndex:addressString.length-1];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/tcserver/eth/ethGetBalances?ethAddresses=%@",TCUrl,addressString];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8));
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:encodeStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            success(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            fail(error.localizedDescription);
        });
    }];
    
    
}

#pragma mark - 获取nonce
+ (void)queryNonceWithWalletAddress:(NSString *)walletAddress success:(SuccessBlock)success fail:(FailBlock)fail{
    NSString *urlString = [NSString stringWithFormat:@"%@/tcserver/eth/ethGetTransactionCount?ethAddress=%@",TCUrl,walletAddress];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8));
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:encodeStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            success(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            fail(error.localizedDescription);
        });
    }];
}

#pragma mark - 转账
+ (void)transferMoneyWithFromPhone:(NSString *)fromPhone toPhone:(NSString *)toPhone fromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress value:(NSString *)value signedTransaction:(NSString *)signedTransaction success:(SuccessBlock)success fail:(FailBlock)fail{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/tcserver/eth/ethSendRawTransaction?fromUserId=%@&toUserId=%@&fromEthAddress=%@&toEthAddress=%@&value=%@&signedTransactionData=%@",TCUrl,fromPhone,toPhone,fromAddress,toAddress,value,signedTransaction];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8));
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:encodeStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            success(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            fail(error.localizedDescription);
        });
    }];
}


+ (void)transferWithPasssword:(NSString *)password
                      toPhone:(NSString *)toPhone
                    toAddress:(NSString *)toAddress
                   moneyValue:(NSString *)moneyValue
                      success:(SuccessBlock)success
                         fail:(FailBlock)fail{
    
    Wallet *wallet = [WalletManager sharedWallet];
    CloudKeychainSigner *signer = (CloudKeychainSigner *)wallet.accounts[wallet.activeAccountIndex];
    [self transferWithSigner:signer passsword:password toPhone:toPhone toAddress:toAddress moneyValue:moneyValue success:success fail:fail];
}

+ (void)transferWithSigner:(CloudKeychainSigner *)signer passsword:(NSString *)password toPhone:(NSString *)toPhone toAddress:(NSString *)toAddress moneyValue:(NSString *)moneyValue success:(SuccessBlock)success fail:(FailBlock)fail{
    
    NSString *fromUserId = [EnvironmentVariable getIMUserID];
    NSString *fromAddress = [signer.address checksumAddress];
    // 1.验证密码
    [signer unlockPassword:password callback:^(Signer *signer, NSError *error) {
        if (error) {
            fail(@"密码错误，请重试");
        } else {
            // 2.获取nonce
            [self queryNonceWithWalletAddress:fromAddress success:^(id result) {
                if ([[result valueForKey:@"result"] isEqualToString:@"success"] ) {
                    NSString *nonce = [NSString stringWithFormat:@"%@",[result valueForKey:@"transactionCount"]];
                    // 3.转账
                    CloudKeychainSigner * cSigner = (CloudKeychainSigner *)signer;
                    Transaction *transaction = [Transaction transaction];
                    transaction.fromAddress = [Address addressWithString: fromAddress];
                    transaction.toAddress = [Address addressWithString: toAddress];
                    transaction.nonce = [nonce integerValue];
                    transaction.value = [BigNumber bigNumberWithDecimalString:moneyValue]; //金额
                    transaction.data = nil; //合约
                    transaction.chainId = nil;
                    transaction.gasLimit = [BigNumber bigNumberWithInteger:4300000];
                    transaction.gasPrice = [BigNumber bigNumberWithInteger:22000000000];
                    NSString *hexTransaction = [cSigner transactionHexString:transaction];
                    
                    
                    [self transferMoneyWithFromPhone:fromUserId toPhone:toPhone fromAddress:fromAddress toAddress:toAddress value:moneyValue signedTransaction:hexTransaction success:^(id result) {
                        if ([[result valueForKey:@"result"] isEqualToString:@"success"] && !StringIsEmpty([result valueForKey:@"transactionHash"])) {
                            success(result);
                        }else{
                            fail(@"转账失败");
                        }
                    } fail:^(NSString *errorDescription) {
                        fail(@"请求错误，转账失败");
                    }];
                }else{
                    fail(@"转账失败");
                }
            } fail:^(NSString *errorDescription) {
                fail(@"请求错误，转账失败");
            }];
        }
    }];
}


#pragma mark - 获取银钻数
+ (void)getSilverDiamondNumWithSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    NSString *token = [TokenRequestManager access_token];
    NSString *urlString = [NSString stringWithFormat:@"%@/tcserver/integral/integralTotal?access_token=%@",TCUrl,token];
    NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8));
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:encodeStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TokenRequestManager isTokenExpiredWithResponse:responseObject complete:^(BOOL isTokenExpired){
                if (isTokenExpired) {
                    [self getSilverDiamondNumWithSuccess:success fail:fail];
                }else{
                    success(responseObject);
                }
            }];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            fail(error.localizedDescription);
        });
    }];
}


@end

