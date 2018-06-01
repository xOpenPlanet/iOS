//
//  OrganizationsMessage.h
//  ESPChatComps
//
//  Created by YRH on 2018/3/29.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMStructMessage.h"
#import "EnvironmentVariable.h"

@interface OrganizationsMessage : NSObject

/// 组织message消息
+ (IMStructMessage *)organizationsMessageWithToUserID:(int)toUserID postType:(postType)postType subtype:(subtype)subtype messageString:(NSString *)messageString;

@end
