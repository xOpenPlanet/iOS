//
//  EFChatListModel.h
//  ESPChatComps
//
//  Created by 虎 谢 on 16/8/9.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMStructMessage.h"
#import "MessageModel.h"
@interface EFChatListModel : NSObject


///1.登录用户ID
@property(nonatomic,assign)  int                loginUserId;
///2.当前聊天用户ID
@property(nonatomic,assign)  int                userId;
///3.用户姓名
@property(nonatomic,strong)  NSString           *userName;
///4.未读消息数目
@property(nonatomic,strong)  NSString           *badgerNum;
///5.是否置顶
@property(nonatomic,assign)  BOOL               isTop;
///6.是否免打扰
@property(nonatomic,assign)  BOOL               isBother;
///7.是否正在发送
@property(nonatomic,assign)  BOOL               isSend;
///8.聊天类型
@property(nonatomic,strong)  NSString           *type;
///9.消息结构体
@property(nonatomic,strong)  IMStructMessage    *message;
///10.用户头像
@property(nonatomic,strong)  NSString           *userAvatar;
///11.设置最后一条信息及未读数目
@property(nonatomic,strong)  MessageModel       *messageModel;
///12.草稿
@property (nonatomic,copy)   NSString           *draft;
///13.localtime  列表排序的时间
@property(nonatomic, assign) long long          *localTime;

@end
