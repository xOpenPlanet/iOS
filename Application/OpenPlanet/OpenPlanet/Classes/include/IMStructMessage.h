//
//  IMStructMessage.h
//  IOSESPBase
//
//  Created by Javor on 16/4/10.
//  Copyright (c) 2016年 JavorFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IIMStruct.h"

#define kMESSAGE_STATE_WAITSEND      0//待发送
#define kMESSAGE_STATE_PRESEND       1//预发送
#define kMESSAGE_STATE_SENDING       2//发送中
#define kMESSAGE_STATE_DELIVER       5//已投递
#define kMESSAGE_STATE_FAILURE       10//发送失败
#define kMESSAGE_STATE_SEND          15//已发送
#define kMESSAGE_STATE_RECEIVE       20//已送达
#define kMESSAGE_STATE_READ          25//已查看
#define kMESSAGE_STATE_UNREAD        30//未查看
#define kMESSAGE_STATE_DELETE        35//删除

@interface IMStructMessage : NSObject <IIMStruct>

@property (nonatomic, assign) int state;
@property (nonatomic, assign) int readState;
@property (atomic, retain) NSMutableDictionary *extDictionary;


- (void)putExtra:(id)object forKey:(NSString *)key;
- (id)extraForKey:(NSString *)key;

@end

