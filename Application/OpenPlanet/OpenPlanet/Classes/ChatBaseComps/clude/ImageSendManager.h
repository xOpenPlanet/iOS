//
//  ImageSendManager.h
//  ESPChatComps
//
//  Created by YRH on 2018/3/29.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFMessageManager.h"

@interface ImageSendManager : NSObject

+ (IMStructMessage *)imagePreSendMessageWithToUserID:(int)toUserID postType:(Byte)postType localPath:(NSString *)localPath scale:(NSString *)scale;

+ (void)imageSendWithMessage:(IMStructMessage *)structMessage url:(NSString *)url;

@end
