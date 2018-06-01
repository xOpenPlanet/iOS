//
//  MessageDataManager.h
//  TalkChain
//
//  Created by Javor Feng on 2018/3/13.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EFChatHttpManager.h"

@class MessageDataManager;

@protocol MessageDataManagerDelegate <NSObject>
@optional

- (void)onMessageComplete:(MessageDataManager *)messageManager;

@end

@interface MessageDataManager : NSObject

typedef void(^successBlock)(id result);
typedef void(^failBlock)(id result);

@property(nonatomic,strong) EFChatHttpManager *httpManager;
@property(nonatomic, weak) id<MessageDataManagerDelegate> delegate;

-(void)isFirstLoading;

-(void)requesetChatAddressBookDataSuccess:(successBlock)success fail:(failBlock)fail;
-(void)requestPublicDataSuccess:(successBlock)success fail:(failBlock)fail;
-(void)requestGroupListDataSuccess:(successBlock)success fail:(failBlock)fail;

@end
