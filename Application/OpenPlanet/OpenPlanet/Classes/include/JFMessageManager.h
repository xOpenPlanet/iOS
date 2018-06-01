//
//  JFMessageManager.h
//  IOSESPBase
//
//  Created by Javor on 16/7/27.
//  Copyright © 2016年 JavorFeng. All rights reserved.
//  消息管理类
//

#import <Foundation/Foundation.h>
#import "IMStructMessage.h"
#import "JFSocketManager.h"
#import "MessageModel.h"
#import "MessageDbManager.h"
#import "MessageModelDBManager.h"

@class JFMessageManager;

@protocol JFMessageManagerDelegate <NSObject>
@optional

- (void)onMessage:(JFMessageManager *)messageManager didReceiveStruct:(id<IIMStruct>)imStruct;
- (void)onMessage:(JFMessageManager *)messageManager didUpdateStruct:(id<IIMStruct>)imStruct;
- (void)onMessage:(JFMessageManager *)messageManager didFailureStruct:(id<IIMStruct>)imStruct;

- (void)onMessageManagerStartConnecting:(JFMessageManager *)messageManager;
- (void)onMessageManagerDidConnect:(JFMessageManager *)messageManager;
- (void)onMessageManagerDidDisConnect:(JFMessageManager *)messageManager;

@end

@interface JFMessageManager : NSObject <JFSocketManagerDelegate>

@property(nonatomic, assign) int socketOffType;

///单例模式
+ (JFMessageManager *)sharedMessageManager;
///连接服务
- (void)doConnect;
///消息未读数量
- (int)unreadCountWithUserID:(int)userID postType:(Byte)postType;
///清空未读数量
- (void)unreadZeroWithUserID:(int)userID postType:(Byte)postType;
///获取个人聊天记录
- (NSMutableArray *)personalHistoryMessageWithFromUserID:(NSInteger)fromUserID toUserID:(NSInteger)toUserID messageID:(NSString *)messageID messageCount:(NSInteger)count;
///获取群组聊天记录
- (NSMutableArray *)groupHistoryMessageWithGroupID:(int)groupID messageID:(NSString *)messageID messageCount:(int)count;
///增加message的delegate方法 不用时需要调用removeMessageDelegate:
- (void)addMessageDelegate:(id<JFMessageManagerDelegate>) delegate;
///移除message的delegate方法
- (void)removeMessageDelegate:(id<JFMessageManagerDelegate>) delegate;
///预发送
- (void)preSendMessage:(IMStructMessage *)message;
///预发送消息(字符串)
- (IMStructMessage *)preSendMessageString:(NSString *)messageString toUserID:(int)toUserID postType:(Byte)postType subType:(short)subType extra:(NSMutableDictionary *)extra;
///发送预消息
- (void)sendPreMessage:(IMStructMessage *)message;
///发送消息
- (void)sendMessage:(IMStructMessage *)message;
///发送消息(字符串)
- (IMStructMessage *)sendMessageString:(NSString *)messageString toUserID:(int)toUserID postType:(Byte)postType subType:(short)subType extra:(NSMutableDictionary *)extra;;
///消息重发
-(void)reSendMessage:(IMStructMessage *)message;
///发送已读消息
-(void)sendReadMessage:(IMStructMessage *)message;
-(void)sendStruct:(id<IIMStruct>)structs;
///改变消息状态为未读
-(void)markeMessageAsUnread:(IMStructMessage *)message;
///改变消息状态为已读
- (void)markeMessageAsRead:(IMStructMessage *)message;
///改变消息状态为已读已投递
- (void)markeMessageAsDliver:(IMStructMessage *)message;
///改变消息状态为已读已发送
- (void)markeMessageAsSend:(IMStructMessage *)message;
///改变消息状态
- (void)changeMessage:(IMStructMessage *)message state:(int)code;
///获取消息的MessageModel
- (MessageModel *)messageModelForUserID:(int)userID toUserType:(int)toUserType;
///更新meesageModel到数据库
- (void)updateDBMessageModel:(MessageModel *)messageModel;
///获取messageDBManager
- (MessageDbManager *)messageDBManager;
- (void)message:(IMStructMessage *)message putExtra:(id)extra forKey:(NSString *)key;
- (MessageModel *)messageModelForUserID:(NSString *)userID;
///注销
- (void)logout;

@end

