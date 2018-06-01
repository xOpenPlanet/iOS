//
//  EAI.h
//  IOSESPBase
//
//  Created by wangzhanfeng on 13-11-28.
//  Copyright (c) 2013年 wang zhanFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@interface EAI : NSObject

+(id)GPO;
+(void)setGPO:(id)value;

+(NSString *)getProtocol;
+(void)setProtocol:(NSString *)protocol;
+(NSString *)getServer;
+(void)setServer:(NSString *)server;
+(NSString *)getPort;
+(void)setPort:(NSString *)port;
+(NSString *)getPath;
+(void)setPath:(NSString *)path;
+(NSString *)getService;
+(void)setService:(NSString *)service;
+(NSMutableDictionary *)getSecurityDictionary;
+(void)setSecurityDictionary:(NSMutableDictionary *)aSecurityDictionary;

@end
