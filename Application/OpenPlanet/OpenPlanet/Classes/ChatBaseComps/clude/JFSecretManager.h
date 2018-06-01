//
//  JFSecretManager.h
//  ESPChatComps
//
//  Created by 王胜利 on 2018/5/7.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFMessageItem.h"


@interface JFSecretManager : NSObject

+ (void)secretTapWithMessageItem:(IMStructMessage *)message toDetail:(void(^)(NSString *password))toDetailBlock;

@end
