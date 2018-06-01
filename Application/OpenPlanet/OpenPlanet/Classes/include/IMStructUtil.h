//
//  IMStructUtil.h
//  IOSESPBase
//
//  Created by Javor on 16/8/17.
//  Copyright © 2016年 JavorFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMStructMessage.h"

@interface IMStructUtil : NSObject

+(NSString *)createMessageIDWithMessage:(IMStructMessage *)message;

@end
