//
//  JFMessageCellManager.h
//  ESPChatComps
//
//  Created by Javor on 16/4/12.
//  Copyright (c) 2016年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFMessageItem.h"

@interface JFMessageCellManager : NSObject

+ (id<JFMessageItem>)messageItemWithType:(short)type;
+ (id<JFMessageItem>)createMessageItemWithType:(short)subtype;

@end
