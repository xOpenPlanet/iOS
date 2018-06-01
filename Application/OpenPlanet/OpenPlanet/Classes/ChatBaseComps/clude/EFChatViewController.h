//
//  ChatVC.h
//  XHWeiXin
//
//  Created by 虎 谢 on 15/11/11.
//  Copyright © 2015年 谢虎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatKeyBoard.h"
#import "EFChatListViewController.h"
#import "MessageDbManager.h"
#import "EnvironmentVariable.h"
#import "EFChatHttpManager.h"
#import "JFMessageBaseCell.h"
#import "ChatDetailViewController.h"
#import "ViewControllerManager.h"
#import "EFUIViewController.h"

typedef enum{
    /**个人到个人*/
    PersonType = (Byte)0,
    /**个人到群组*/
    groupType = (Byte)1,
}chatType;

typedef enum{
    /**群主权限*/
    GroupOwner      = (Byte)0,
    /**管理员权限*/
    GroupManager    = (Byte)1,
    /**所有人权限*/
    GroupAll        = (Byte)2,
    /**群主和管理员权限*/
    GroupOM         = (Byte)3,
}groupPermission;

@protocol EFChatViewControllerDelegate <NSObject>

/// 数组中所有 图片类型的message
- (void)showImageItemAllImages:(NSMutableArray *)allImgArray;

@end


@interface EFChatViewController : EFUIViewController<UITextFieldDelegate,ChatKeyBoardDelegate,ChatKeyBoardDataSource>
{
    EFChatHttpManager           *_userManager;
    JFMessageManager            *_messageManager;
    MessageDbManager            *_messageDBManager;
    UIActivityIndicatorView     *_activityView;             //下拉加载的小菊花
    IMStructMessage             *_theFirstMessage;          //此页面的第一条信息
}
/// 数据源
@property (nonatomic, strong) NSMutableArray    *resultArray;
/// 自定义键盘
@property (nonatomic, strong) ChatKeyBoard      *chatKeyBoard;
/// 信息发送目的地的id
@property (nonatomic, assign) long long         currentID;
/// 用户昵称
@property (nonatomic, copy) NSString            *nickName;
/// 消息投递分类
@property (nonatomic, assign) Byte              chatType;
/// 头像形状
@property (nonatomic, assign) Byte              cellHeaderImageViewShape;
/// 群组权限管理
@property (nonatomic, assign) Byte              groupPermission;
/// 来消息是否有声音或震动提醒
@property (nonatomic, assign) BOOL              disturbOrNudisturb;
///
@property (nonatomic, strong) MessageModel      *messageModel;
/// title text
@property (nonatomic, copy)   NSString          *nameString;
/// 第一条信息
@property (nonatomic, strong) IMStructMessage   *theFirstMessage;
/// title
@property (nonatomic, strong) UILabel           *nameLabel;
/// count
@property (nonatomic, strong) UILabel           *countLabel;
/// 当前聊天人 或 群组 的信息（免打扰或不免打扰）
@property (nonatomic, strong) NSDictionary      *thisChatInfoDic;
/// 聊天tableView
@property (nonatomic, strong) UITableView       *tabView;
/// 提示图
@property (nonatomic, strong) UILabel           *touseLabel;
///
@property (nonatomic, assign) BOOL              isShowPlaceHolderCell;
/// 群组成员是否是好友集合   YES:是好友
@property (nonatomic, strong) NSMutableDictionary *fromUserIDset;
@property (nonatomic, assign) BOOL              isConnectShow;
/// 上次滑动将要出现的消息id
@property (nonatomic, copy)   NSString          *lastScrollMessageID;

@property (nonatomic, weak) id<EFChatViewControllerDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withUserID:(int)currentID;

- (instancetype)initWithUserID:(long long)currentID;

- (void)timeControl;

- (void)tableViewScrollToBottom;

- (BOOL)isScrollToBottom;

//- (void)loadGroupMembers;

@end
