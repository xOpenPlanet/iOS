//
//  YContactsManager.m
//  YAddressBookDemo
//
//  Created by YueWen on 16/5/6.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RITLContactsManager.h"
#import "ContactManager.h"
#import "AddressBookContactManager.h"


@interface RITLContactsManager ()

///负责针对AddressBook进行数据请求的类
@property (nonatomic, strong) AddressBookContactManager * addressBookContactManager;
///负责针对Contact进行数据请求的类
@property (nonatomic, strong) ContactManager * contactManager NS_AVAILABLE_IOS(9_0);

@end



@implementation RITLContactsManager


-(instancetype)init{
    if (self = [super init]){
        if (@available(iOS 9.0, *)) {
            self.contactManager = [[ContactManager alloc]init];
        }else {
            self.addressBookContactManager = [[AddressBookContactManager alloc]init];
        }
    }
    return self;
}


-(void)dealloc{
    NSLog(@"[dealloc]-[%@]",NSStringFromClass([self class]));
}



#pragma mark - 请求通讯录
/// 请求通讯录
-(void)requestContactsComplete:(void (^)(NSArray<RITLContactObject *> * _Nonnull))completeBlock defendBlock:(nonnull void (^)(void))defendBlock{
    if (@available(iOS 9.0, *)) {
        //如果是contact
        self.contactManager.descriptors = self.descriptors;
        self.contactManager.contactDidChange = self.contactDidChange;
        [self.contactManager requestContactsComplete:^(NSArray<RITLContactObject *> * _Nonnull contacts) {
            completeBlock(contacts);
        } defendBlock:^{
            defendBlock();
        }];
    } else {
        self.addressBookContactManager.addressBookDidChange = self.contactDidChange;
        //如果是addressBook
        [self.addressBookContactManager requestContactsComplete:^(NSArray<RITLContactObject *> * _Nonnull contacts) {
            completeBlock(contacts);
        } defendBlock:^{
            defendBlock();
        }];
    }
}




@end

