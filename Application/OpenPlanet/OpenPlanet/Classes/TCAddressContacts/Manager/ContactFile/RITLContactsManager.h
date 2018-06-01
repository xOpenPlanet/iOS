//
//  YContactsManager.h
//  YAddressBookDemo
//
//  Created by YueWen on 16/5/6.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RITLContactObject;
@protocol CNKeyDescriptor;

NS_ASSUME_NONNULL_BEGIN


@interface RITLContactsManager : NSObject

///想要获得的键值描述，详见NSString+RITLContactFile.m 或者 CNContact.h,默认为RITLContactAllKeys
@property (nonatomic, copy)NSArray <id<CNKeyDescriptor>> * descriptors NS_AVAILABLE_IOS(9_0);

///通讯录发生变化进行的回调，返回更新完毕的RITLContactObject对象数组
@property (nonatomic, copy)void(^contactDidChange)(NSArray<RITLContactObject *>*);

///请求所有的联系人
/// @param completeBlock 获取到数据完成的回调
/// @param defendBlock   没有权限进行的回调
- (void)requestContactsComplete:(void (^)(NSArray <RITLContactObject *> *))completeBlock defendBlock:(void(^)(void)) defendBlock;

@end



NS_ASSUME_NONNULL_END


