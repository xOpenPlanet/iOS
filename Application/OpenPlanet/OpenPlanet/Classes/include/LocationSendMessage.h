//
//  SendMessageManager.h
//  ESPChatComps
//
//  Created by 亦晴 on 2018/5/4.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LocationSendMessage : NSObject
- (void) sendLocationMessage:(NSDictionary *)dic SnapshotImage:(UIImage *)image WithImagePath:(NSString *)path;
@end
