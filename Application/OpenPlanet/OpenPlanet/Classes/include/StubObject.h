//
//  StubObject.h
//  HessianTest
//
//  Created by wangzhanfeng on 13-10-14.
//  Copyright (c) 2013年 wangzhanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StubObject : NSObject<NSCoding>
@property (nonatomic, copy  ) NSString *icon;
@property (nonatomic, retain) StubObject *parent;
@property (nonatomic, retain) NSMutableArray *children;
@property (nonatomic, retain) NSMutableArray *childList;
@property (nonatomic, copy  , setter = setCaptionParam:, getter = getCaptionParam) NSString *caption;
@property (nonatomic, strong) NSMutableDictionary *stubTable;

-(void)addChildWithStubObject:(StubObject *)child;

-(NSString *)toString;

-(NSString *)getID;

-(void)setCaption:(NSString *)caption;

-(NSString *)getCaption;

-(NSMutableDictionary *)getStubTable;

-(void)setStubTable:(NSMutableDictionary *)aStubTable;

-(NSString *)getStringForKey:(id)key withDefaultValue:(NSString *)def;

-(void)setString:(NSString *)value forAKey:(NSString *)key;

-(id)getObjectForKey:(NSString *)key withDefaultValue:(id)def;

-(void)setObject:(id)value forAKey:(id)aKey;

-(void)setBoolean:(BOOL)value forAKey:(NSString *)aKey;

+(StubObject *)getStubObjectForClazz:(NSString *)clazzName;

-(NSString *)getNodeText;

-(void)setNodeText:(NSString *)nodeText;

-(NSString *)getStubID;

-(void)setStubID:(NSString *)stubID;

@end
