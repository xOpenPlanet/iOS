//
//  EFMessageOfficeItem.h
//  ESPChatComps
//
//  Created by 吴鹏 on 17/6/13.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFMessageItem.h"

typedef enum {
    /**未下载*/
    itemState_undownload = 0,
    /**已下载*/
    itemState_downloaded = 1,
    /**暂停下载*/
    itemState_pause      = 2,
    /**正在下载*/
    itemState_restate    = 3,
    /**正在发送*/
    itemState_sending    = 4,
    /**已发送*/
    itemState_sended     = 5,
    /**已删除*/
    itemState_isdeleted  = 6,


} itemState;

@protocol EFMessageOfficeItemDelegate <NSObject>

///修改消息的代理方法
- (void)changeMessage:(IMStructMessage *)message;

@end

@interface EFMessageOfficeItem : NSObject<JFMessageItem>

@property (nonatomic, assign) BOOL isNeedDownload;
///itemState（未下载、已下载、暂停下载、正在下载、正在发送、已发送）
@property (nonatomic, assign) Byte itemState;
///发送人ID
@property (nonatomic, assign) int fromUserID;
///接受者ID
@property (nonatomic, assign) int toUserID;
///Item代理
@property (nonatomic, weak) id<EFMessageOfficeItemDelegate> delegate;
///修改上传时的进度
- (void)changeProcessPercent:(CGFloat)percent;

@end
