//
//  ConfigSettingManager.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/13.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingFileManager : NSObject

#pragma mark - bundle相关
/// 默认配置Bundle路径
+ (NSString *)defaultConfigSettingPath;

/// 将配置文件bundle拷贝到沙盒默认路径
+ (BOOL)copyConfigSettinBundleToDefaultPath;

/// 将配置文件bundle拷贝到沙盒自定义路径
+ (BOOL)copyConfigSettingBundleToOtherPath:(NSString *)toPath;

/**
 拷贝自定义bundle到沙盒

 @param bundleName bundleName
 @param toPath 存储路径
 @return 是否拷贝成功
 */
+ (BOOL)copyCustomBundleWithBundleName:(NSString *)bundleName toPath:(NSString *)toPath;


#pragma mark - file相关
/**
 拷贝自定义文件到沙盒

 @param filePath 文件源路径
 @param toPath 存储路径
 @return 是否拷贝成功
 */
+ (BOOL)copyFileFromfilePath:(NSString *)filePath toPath:(NSString *)toPath;

/**
 移动item位置

 @param path 原路径
 @param toPath 新路径
 @return 是都移动成功
 */
+ (BOOL)moveItemFromPath:(NSString *)path toPath:(NSString *)toPath;

@end
