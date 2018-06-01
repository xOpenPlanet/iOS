//
//  MessageModelDBManager.h
//  ESPChatComps
//
//  Created by 苏友龙 on 16/11/25.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"

@interface MessageModelDBManager : NSObject

///向MessageModel插入数据
- (void)insertMessageModel:(MessageModel *)model;

///向MessageModel插入数据
- (void)insertMessageModelArray:(NSMutableArray *)modelArray;

///更新MessageModel数据
- (void)updateMessageModel:(MessageModel *)model;

///更新MessageModel数据
- (void)updateMessageModelArray:(NSMutableArray *)modelArray;

///删除MessageModel数据
- (void)deleteMessageModel:(MessageModel *)model;

///删除MessageModel数据
- (void)deleteMessageModelArray:(NSMutableArray *)modelArray;

///查询MessageModel和Message数据
- (MessageModel *)selectMessageModel:(NSString *)userID;

@end
