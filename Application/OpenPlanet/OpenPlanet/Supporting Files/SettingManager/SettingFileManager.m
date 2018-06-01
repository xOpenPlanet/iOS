//
//  ConfigSettingManager.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/13.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "SettingFileManager.h"
#import "TalkChainHeader.h"

static NSString *defaultBundle = @"ConfigSetting.bundle";

@implementation SettingFileManager

#pragma mark - 拷贝Bundle
#pragma mark 默认配置文件路径
+ (NSString *)defaultConfigSettingPath{
    return [DOCUMENT_PATH stringByAppendingString:@"/Package"];
}

#pragma mark  拷贝默认配置文件到默认路径
+ (BOOL)copyConfigSettinBundleToDefaultPath{
    NSString *path = [[NSBundle mainBundle] pathForResource:defaultBundle ofType:nil];
    NSString *toPath = [self defaultConfigSettingPath];

    NSFileManager *fileManager = [NSFileManager new];
    /// 如果有旧的移除旧文件
    if([fileManager fileExistsAtPath:toPath]){
        [fileManager removeItemAtPath:toPath error:nil];
    }
    /// 创建存储路径
    [fileManager createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager removeItemAtPath:toPath error:nil];

    NSError *error;
    BOOL isSuccess =  [fileManager copyItemAtPath:path toPath:toPath error:&error];
    return isSuccess;
}

#pragma mark 拷贝默认配置文件bundle到其他路径
+ (BOOL)copyConfigSettingBundleToOtherPath:(NSString *)toPath{
    NSString *path = [[NSBundle mainBundle] pathForResource:defaultBundle ofType:nil];
    NSFileManager *fileManager = [NSFileManager new];
    /// 如果有旧的移除旧文件
    if([fileManager fileExistsAtPath:toPath]){
        [fileManager removeItemAtPath:toPath error:nil];
    }
    /// 创建存储路径
    [fileManager createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager removeItemAtPath:toPath error:nil];

    NSError *error;
    BOOL isSuccess =  [fileManager copyItemAtPath:path toPath:toPath error:&error];
    return isSuccess;
}

#pragma mark 拷贝自定义Bundle到沙盒路径
+ (BOOL)copyCustomBundleWithBundleName:(NSString *)bundleName toPath:(NSString *)toPath{
    NSString *path = [[NSBundle mainBundle] pathForResource:bundleName ofType:nil];

    NSFileManager *fileManager = [NSFileManager new];
    /// 如果有旧的移除旧文件
    if([fileManager fileExistsAtPath:toPath]){
        [fileManager removeItemAtPath:toPath error:nil];
    }

    /// 创建存储路径
    [fileManager createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager removeItemAtPath:toPath error:nil];
    NSError *error;
    BOOL isSuccess =  [fileManager copyItemAtPath:path toPath:toPath error:&error];
    return  isSuccess;
}


#pragma mark - 拷贝文件
#pragma mark  拷贝文件到自定义路径
+(BOOL)copyFileFromfilePath:(NSString *)filePath toPath:(NSString *)toPath{
    NSFileManager *fileManager = [NSFileManager new];
    /// 如果有旧的移除旧文件
    if([fileManager fileExistsAtPath:toPath]){
        [fileManager removeItemAtPath:toPath error:nil];
    }

    /// 创建存储路径
    [fileManager createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager removeItemAtPath:toPath error:nil];

    NSError *error;
    BOOL isSuccess =   [fileManager copyItemAtPath:filePath toPath:toPath error:&error];
    return isSuccess;
}



#pragma mark - 移动
#pragma mark 移动item从某个位置到某个位置
+ (BOOL)moveItemFromPath:(NSString *)path toPath:(NSString *)toPath{
    NSFileManager *fileManager = [NSFileManager new];
    /// 如果有旧的移除旧文件
    if([fileManager fileExistsAtPath:toPath]){
        [fileManager removeItemAtPath:toPath error:nil];
    }

    /// 创建存储路径
    [fileManager createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager removeItemAtPath:toPath error:nil];
  
    NSError *error;
    BOOL isSuccess =  [fileManager moveItemAtPath:path toPath:toPath error:&error];
    return isSuccess;
}


@end
