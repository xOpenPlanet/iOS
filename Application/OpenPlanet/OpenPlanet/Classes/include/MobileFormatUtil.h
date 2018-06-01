//
//  MobileFormatUtil.h
//  IOSESPBase
//
//  Created by JavorFeng on 13-12-4.
//  Copyright (c) 2013年 JavorFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileFormatObject.h"
#import "GDataXMLNode.h"

@interface MobileFormatUtil : NSObject

+(void)createFMTListWithXML:(NSString *) xml;
+(void)createFMTWithNode:(GDataXMLElement *)node forFMTObject:(MobileFormatObject *)FMTObject;
+(MobileFormatObject *)getFMTWithID:(NSString *)pid;
+(NSString *)getSerKeyWithID:(NSString *)pid;   
@end
