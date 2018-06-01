//
//  MessageModel.h
//  IOSESPBase
//
//  Created by Javor on 16/8/12.
//  Copyright © 2016年 JavorFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMStructMessage.h"

@interface MessageModel : NSObject

@property(nonatomic, assign) int                    unreadCount;
@property(nonatomic, assign) int                    userType;
@property(nonatomic, strong) NSString               *userID;
@property(nonatomic, strong) NSMutableArray         *array;
@property(nonatomic, strong) NSMutableDictionary    *map;
@property(nonatomic, weak)   IMStructMessage        *lastMessage;

///默认更新数据库
-(void)addMessage:(IMStructMessage *)message;
-(void)addMessage:(IMStructMessage *)message updateDB:(BOOL)updateDB;
-(void)addMessage:(IMStructMessage *)message atIndex:(int)index updateDB:(BOOL)updateDB;
-(IMStructMessage *)messageForKey:(NSString *)key;
-(void)messageUnread:(IMStructMessage *)message;
-(void)messageRead:(IMStructMessage *)message;
-(void)unreadZero;

@end
