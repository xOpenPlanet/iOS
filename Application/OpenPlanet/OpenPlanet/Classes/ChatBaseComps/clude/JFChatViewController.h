//
//  JFChatViewController.h
//  ChatComps
//
//  Created by Javor Feng on 2018/3/14.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JFMessageManager.h"
#import "EFChatKeyBoard.h"


@interface JFChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, JFMessageManagerDelegate>

@property(nonatomic, copy) NSString *toUserName;
@property(nonatomic, assign) int toUserID;
@property(nonatomic, assign) NSInteger currentUserID;                 //当前用户ID
@property(nonatomic, assign) Byte postType;

@property(nonatomic, strong) MessageModel *messageModel;
@property(nonatomic, strong) JFMessageManager *messageManager;
@property(nonatomic, strong) NSMutableArray *messageArray;

/// 自定义键盘
@property(nonatomic, strong) EFChatKeyBoard *chatKeyBoard;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)  UILabel *titleLabel;
@end
