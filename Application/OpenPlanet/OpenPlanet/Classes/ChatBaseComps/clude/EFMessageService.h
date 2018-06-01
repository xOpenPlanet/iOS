//
//  EFMessageService.h
//  ESPChatComps
//
//  Created by 陈海鹏,谢虎 on 2017/3/16.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFMessageManager.h"
#import "IBadgeView.h"

@interface EFMessageService : NSObject<JFMessageManagerDelegate,JFSocketManagerDelegate,UIAlertViewDelegate>
//聊天列表的数据源
@property (nonatomic,strong )NSMutableArray  *listArray;
//key:id  value:count
@property (nonatomic,strong )NSMutableDictionary *menuMap;
//key:id  value:包含所有标记该id的view
@property (nonatomic,strong )NSMutableDictionary *viewMap;
//key: xml节点ID   value：所有关联的appid
@property (nonatomic,strong )NSMutableDictionary *treeMap;

@property(nonatomic, weak) id<IBadgeView>      kjBadgeView;

+ (instancetype)sharedMessageService;
///获取任务数据源
-(void)taskList;
///获取未读数目
- (void)prepareOpeartion;
///建立消息连接
- (void)connectManager;
///移除消息链接
- (void)removeMessageDelegate;

- (void)unreadcountRefresh;

//是否应用号消息
- (BOOL)isApplyAction:(NSString *)userIdStr;



@end
