//
//  SyncFansUtil.h
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/25.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkChainHeader.h"

@interface SyncFansUtil : NSObject

/// 请求通讯录权限
+ (void)requestAuthorizationAddressBook;
/// 同步通讯录
/// noAuthor : 未授权
/// success : 同步成功
/// noAuthor : 同步失败
+ (void)syncFansWithNoAuthor:(VoidBlock)noAuthor success:(SuccessBlock)success fail:(FailBlock)fail;

@end
