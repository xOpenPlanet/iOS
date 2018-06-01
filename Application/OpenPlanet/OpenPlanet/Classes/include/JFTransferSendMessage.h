//
//  JFTransferSendMessage.h
//  ESPChatComps
//
//  Created by YRH on 2018/4/27.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "JFMessageManager.h"

@interface JFTransferSendMessage : NSObject

+ (void)sendTransferMessageWithToUserId:(NSString *)toUserId transferMessageString:(NSString *)messageString;

@end
