//
//  WalletOther.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/22.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "WalletUtil.h"
#import "Constant.h"
#import "EnvironmentVariable.h"
#import "MessageDbManager.h"
#import "YYRSACrypto.h"
#import "TCLoginManager.h"



static WalletUtil *other = nil;
@implementation WalletUtil

+ (instancetype)shared{
    if(other == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            other = [[WalletUtil alloc]init];
        });
    }
    return other;
}




#pragma mark - 保存钱包图片

+ (void)saveWalletAccountImage:(UIImage *)image imageName:(NSString *)imageName{
    NSString *folderPath = [NSString stringWithFormat:@"%@/walletImage/%@",DOCUMENT_PATH,[EnvironmentVariable getWalletUserID]];  // 保存文件的名称

    NSFileManager *fileManager = [NSFileManager new];
    /// 如果有旧的移除旧文件
    if(![fileManager fileExistsAtPath:folderPath]){
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSString *filePath  = [folderPath stringByAppendingPathComponent:imageName];

    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES]; // 保存成功会返回YES
    if (result == YES) {
//        Log(@"保存成功");
    }

}
#pragma mark - 获取钱包图片

+ (UIImage *)getWalletAccountImageWithImageName:(NSString *)imageName{
    NSString *folderPath = [NSString stringWithFormat:@"%@/walletImage/%@",DOCUMENT_PATH,[EnvironmentVariable getWalletUserID]];  // 保存文件的名称
    NSString *filePath  = [folderPath stringByAppendingPathComponent:imageName];
    return [UIImage imageWithContentsOfFile:filePath];
}

#pragma mark - 获取当前钱包

+ (CloudKeychainSigner *)getCurrentWallet{
    NSString *netEthAddress = [EnvironmentVariable getPropertyForKey:@"ethAddress" WithDefaultValue:@""];
    netEthAddress = [([netEthAddress hasPrefix:@"0x"]?@"":@"0x") stringByAppendingString:netEthAddress];
    Wallet *wallet = [WalletManager sharedWallet];


    for (int i = 0; i < wallet.accounts.count ; i ++) {
        CloudKeychainSigner *signer = (CloudKeychainSigner *)wallet.accounts[i];
        Address *address = signer.address;
        NSString *addressString = [address checksumAddress];
        if ([[addressString uppercaseString] isEqualToString:[netEthAddress uppercaseString]]) {
            wallet.activeAccountIndex = i;
            return signer;
        }
    }
    return nil;
}


#pragma mark - 保存通讯公钥和私钥

+ (void)saveComPublicKey:(NSString *)comPublicKey comPrivateKey:(NSString *)comPrivateKey{
    [EnvironmentVariable setProperty:SafeString(comPublicKey) forKey:[self comPublicKey]];
    [EnvironmentVariable setProperty:SafeString(comPrivateKey) forKey:[self comPrivateKeyName]];
}


#pragma mark - 获取通讯公钥

+ (NSString *)comPublicKey{
    return [EnvironmentVariable getPropertyForKey:[self comPublicKeyName] WithDefaultValue:@""];
}

#pragma mark - 获取通讯私钥

+ (NSString *)comPrivateKey{
    return [EnvironmentVariable getPropertyForKey:[self comPrivateKeyName] WithDefaultValue:@""];
}


#pragma mark - 获取通讯公钥key

+ (NSString *)comPublicKeyName{
    return  [NSString stringWithFormat:@"%@_comPulicKey",[EnvironmentVariable getIMUserID]];
}

#pragma mark - 获取通讯私钥key

+ (NSString *)comPrivateKeyName{
    return [NSString stringWithFormat:@"%@_comPrivateKey",[EnvironmentVariable getIMUserID]];
}


#pragma mark - 兼容旧版本没有通讯私钥字段

+ (void)compatibleComPrivateKey{
    NSString *envComPublicKey = [EnvironmentVariable getPropertyForKey:@"comPublicKey" WithDefaultValue:@""];
    /// 通讯私钥为空时，创建并同步
    if (StringIsEmpty([self comPrivateKey]) || StringIsEmpty(envComPublicKey))  {
        [YYRSACrypto rsa_generate_key:^(MIHKeyPair *keyPair, bool isExist) {
            NSString *comPublicKey = [YYRSACrypto getPublicKey:keyPair];
            NSString *comPrivateKey = [YYRSACrypto getPrivateKey:keyPair];
            // ENV存储通讯公钥和私钥
            [self saveComPublicKey:comPublicKey comPrivateKey:comPrivateKey];
            [TCLoginManager updateComPublicKey:comPublicKey success:^(id result) {

            } fail:^(NSString *errorDescription) {

            }];
        }archiverFileName:nil];
    }
}

@end
