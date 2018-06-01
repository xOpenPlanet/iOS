//
//  RecentFilesViewController.h
//  ESPChatComps
//
//  Created by 吴鹏 on 17/7/3.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMStructMessage.h"

@protocol RecentFilesDelegate <NSObject>

- (void)recentUpLoadPercent:(CGFloat)percent IMStructMessage:(IMStructMessage *)structMessage;

@end

@interface RecentFilesViewController : UIViewController
@property (nonatomic) UITableView *tableView;
///代理
@property(nonatomic, weak) id<RecentFilesDelegate> delegate;
///来源用户ID
@property(nonatomic, assign) int        fromUserID;
///发送到用户ID
@property(nonatomic, assign) int        toUserID;
/// 消息投递分类
@property (nonatomic, assign) Byte      chatType;


@end
