//
//  JFSocketManager.h
//  IOSESPBase
//
//  Created by Javor on 16/4/9.
//  Copyright (c) 2016年 JavorFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IIMStruct.h"

@class JFSocketManager;

@protocol JFSocketManagerDelegate <NSObject>
@optional

- (void)onSocketDidDisconnect:(JFSocketManager *)socketManager;
- (void)onSocket:(JFSocketManager *)socketManager willDisconnectWithError:(NSError *)err;
- (void)onSocketDidDisconnect:(JFSocketManager *)socketManager;
- (void)onSocketStartConnecting:(JFSocketManager *)socketManager;
- (void)onSocket:(JFSocketManager *)socketManager didConnectToHost:(NSString *)host port:(UInt16)port;
- (void)onSocket:(JFSocketManager *)socketManager didReadData:(NSData *)data withTag:(long)tag;
- (void)onSocket:(JFSocketManager *)socketManager didWriteDataWithTag:(long)tag;
//- (void)onSocket:(JFSocketManager *)socketManager didReadStruct:(id<IIMStruct>)imStruct;

@end

#define kNETWORK_STATE_NONE     0
#define kNETWORK_STATE_WiFi     1
#define kNETWORK_STATE_WWAN     2

#define SocketOfflineByServer    0  //服务器掉线
#define SocketOfflineByUser      1  //用户断开
#define SocketOfflineByWifiCut   2  //wifi断开

#define loginTypeOn    0  //服务器掉线
#define loginTypeOff   1  //服务器掉线


@interface JFSocketManager : NSObject

@property(nonatomic, assign) int socketOffType;
@property(nonatomic, assign) int loginType;
@property(nonatomic, weak)   id<JFSocketManagerDelegate> delegate;
@property(nonatomic, assign) BOOL isConnected;
@property(nonatomic, copy)   NSString *imURL;

///单例模式
+ (JFSocketManager *)sharedSocketManager;
///连接服务器
- (void)startConnect;
///断开服务器连接
- (void)stopConnect;
///发送消息
- (void)sendData:(NSData *)data;


@end
