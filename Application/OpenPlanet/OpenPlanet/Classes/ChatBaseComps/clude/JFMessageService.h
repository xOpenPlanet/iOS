//
//  JFMessageService.h
//  ChatComps
//
//  Created by Javor Feng on 2018/4/4.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFMessageManager.h"

@interface JFMessageService : NSObject <JFMessageManagerDelegate>

+ (JFMessageService *)sharedMessageService;

@end
