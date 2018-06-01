//
//  Registry.h
//  IOSESPBase
//
//  Created by JavorFeng on 13-11-30.
//  Copyright (c) 2013年 JavorFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StubObject.h"

@interface Registry : NSObject

+(void)clearRegistry;
+(void)clearAPPRegistry;
+(NSMutableArray *)creatEntryListWithEntryKey:(NSString *)entryKey;
+(void)regObjectWithEntryKey:(NSString *)entryKey stub:(StubObject *)stub;
+(void)regAPPObjectWithEntryKey:(NSString *)entryKey stub:(StubObject *)stub;
+(NSMutableArray *)getRegEntryListWithKey:(NSString *)entryKey;
+(NSMutableArray *)getAPPRegEntryListWithKey:(NSString *)entryKey;
+(StubObject *)getStubObjectForKey:(NSString *)key;

@end
