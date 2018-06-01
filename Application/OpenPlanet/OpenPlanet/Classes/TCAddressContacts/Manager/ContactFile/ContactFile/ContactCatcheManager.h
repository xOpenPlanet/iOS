//
//  ContactCatcheManager.h
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 负责缓存联系人identifier的类
NS_CLASS_AVAILABLE_IOS(9_0) @interface ContactCatcheManager : NSObject

+(instancetype)sharedInstace;

/// 开始加载通讯录所有的identifier
- (void)startRequestIndentifiers:(void(^)(NSArray <NSString *> *))completeBlock;
/// 重新获取通讯录的identifier
- (void)reloadContactIdentifiers:(void(^)(NSArray <NSString *> *))completeBlock;


@end


NS_ASSUME_NONNULL_END
