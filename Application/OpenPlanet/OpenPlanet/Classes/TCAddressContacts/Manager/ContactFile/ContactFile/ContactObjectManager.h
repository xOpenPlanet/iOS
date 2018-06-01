//
//  RITLContactsObjectManager.h
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/11.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CNContact;
@class CNMutableContact;
@class RITLContactObject;


/// 针对Contacts.framework进行的封装
NS_CLASS_AVAILABLE_IOS(9_0) @interface ContactObjectManager : NSObject

/// 根据CNContact对象获得RITLContactObject对象
+(RITLContactObject *)contantObject:(CNContact *)contact;

@end


@interface ContactObjectManager (CNContact)


/// 根据RITLContactObject对象获得CNContact对象
+(CNMutableContact *)cnContact:(RITLContactObject *)contactObject;

@end

NS_ASSUME_NONNULL_END
