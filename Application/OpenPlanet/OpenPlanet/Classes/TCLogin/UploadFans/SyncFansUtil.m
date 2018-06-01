//
//  SyncFansUtil.m
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/25.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "SyncFansUtil.h"
#import <AddressBook/AddressBook.h>

@implementation SyncFansUtil


#pragma mark - 请求通讯录权限
+ (void)requestAuthorizationAddressBook{
    // 判断是否授权
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    if (authorizationStatus == kABAuthorizationStatusNotDetermined) {
        // 请求授权
        ABAddressBookRef addressBookRef =  ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {  // 授权成功

            } else {        // 授权失败
                NSLog(@"授权失败！");
            }
        });
    }
}


#pragma mark - 下一步
+ (void)syncFansWithNoAuthor:(VoidBlock)noAuthor success:(SuccessBlock)success fail:(FailBlock)fail {
    // 1. 判读授权
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    if (authorizationStatus != kABAuthorizationStatusAuthorized) {
        noAuthor();
        return;
    }
    NSArray *contacts = [self getContacts];
    if (contacts.count > 0) {
        // 2. 获取所有联系人
        [TCLoginManager uploadFansWithFans:contacts progress:^(CGFloat progress) {
        } success:^(id result) {
            if ([[result valueForKey:@"result"] isEqualToString:@"success"]) {
                success(result);
            }else{
                fail(@"同步通讯录失败");
            }
        } fail:^(NSString *errorDescription) {
            Log(@"同步联系人失败 -- %@", errorDescription);
            fail(errorDescription);
        }];
    }else{
        success(@{@"result":@"success"});
    }
}

#pragma mark - 获取联系人
+ (NSArray *)getContacts{
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    long count = CFArrayGetCount(arrayRef);
    NSMutableArray *contacts = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        //获取联系人对象的引用
        ABRecordRef people = CFArrayGetValueAtIndex(arrayRef, i);
        NSInteger peopleId = (NSInteger)ABRecordGetRecordID(people);
        //获取当前联系人名字
        NSString *firstName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
        //获取当前联系人姓氏
        NSString *lastName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
        //获取当前联系人的电话 数组
        ABMultiValueRef phones = ABRecordCopyValue(people, kABPersonPhoneProperty);
        for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
            //电话描述(如住宅、工作..)
            NSString *phoneTitle = (__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phones, j));
            // 电话
            NSString *phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j));
            phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
            phone = [[phone componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
            if (phone.length > 0) {
                NSDictionary *contact = @{
                                          @"linkManUserName":[NSString stringWithFormat:@"%@%@",SafeString(lastName),SafeString(firstName)],
                                          @"unionId":@(peopleId),
                                          @"linkManIdMd5":[StringUtil encodeWithMD5:phone] ,
                                          @"phoneTitle":phoneTitle
                                          };
                [contacts addObject:contact];
            }
        }
    }
    return contacts;
}

@end

