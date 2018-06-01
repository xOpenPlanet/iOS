//
//  MessageDbManager.h
//  FMDBManage
//
//  Created by 李震 on 16/8/9.
//  Copyright © 2016年 pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMStructMessage.h"
#import "EFChatListModel.h"

@protocol MessageDBManagerDelegate <NSObject>

- (void)messageDBManagerBackData:(id)data;

@end

@interface MessageDbManager : NSObject

@property(nonatomic,weak) id<MessageDBManagerDelegate> delegate;

-(NSMutableArray *)chatlistDataWithUserID:(NSInteger)loginUserid;

//根据ID获取nickname
- (NSString *)nameFromUsersWithId:(NSInteger)userID;
//存储聊天列表--群组
- (void)saveChat_ListToDataBase:(NSMutableArray *)chatListArray;
//存储聊天列表--单条形式
- (void)saveChatListToDataBaseBySingle:(EFChatListModel *)chatListModel;
//存储聊天信息
- (void)saveDataToDataBase:(NSMutableArray *)messageArray with:(NSMutableArray *)extentArray;

///创建数据库
- (BOOL)createDataBase;
/// 更新数据库
- (void)updateDataBaseTablesInfo;

///判断表中是否有数据
- (BOOL)isExistDataInFriendsWithLoginUserId:(NSInteger)loginUserId;

///查找表中的所有数据
- (NSMutableArray *)selectAllDataFromTable:(NSString *)tableName;

///向User表中插入数据
- (BOOL)insertIntoUser:(NSMutableArray *)dataArray;

///向User表中插入数据
- (void)insertIntoUserInfor:(NSMutableDictionary *)dataDic;

///向NewFriend表中插入数据
- (BOOL)insertIntoNewFriend:(NSMutableDictionary *)dataDic;

///向Groups里插入数据（插入二维码扫描后的群组）
- (BOOL)insertGroup:(NSMutableDictionary *)dataDic;

///向Groups、GroupUsers和MyGroup表中插入数据(创建群组)
- (BOOL)createChatGroup:(NSMutableDictionary *)dataDic;

///向Groups 和 MyGroup表中插入数据(获取群列表时)
- (BOOL)addChatGroup:(NSMutableDictionary *)dataDic;

///向User和Friends表中插入数据
- (BOOL)insertIntoUserAndFriends:(NSMutableArray *)dataArray loginUserId:(NSInteger)loginUserId;

///向GroupUsers和User表中插入数据(添加群成员)
- (BOOL)insertIntoGroupUsersAndUser:(NSInteger)groupId usersArray:(NSMutableArray *)usersArray;

//向GroupUsers和User表中插入数据(添加群成员)
- (void)insertIntoGroupUsersAndUserInfor:(NSInteger)groupId usersArray:(NSMutableArray *)usersArray;

///向GroupUsers表中插入数据(添加一个群成员)
- (BOOL)insertIntoGroupUsers:(NSInteger)groupId userId:(NSInteger)userId;

///更新NewFriend表（state和time）
- (BOOL)updateNewFriend:(NSMutableDictionary *)dataDic;

///更新GroupUsers表中enable(移除群成员)
- (BOOL)updateGroupUsers:(NSInteger)groupId userId:(NSInteger)userId;

///更新GroupUsers、Groups、MyGroup(自己退群)
- (BOOL)outGroup:(NSInteger)groupId userId:(NSInteger)userId;

///更新Groups表中groupName(更换组名)
- (BOOL)updateGroup:(NSInteger)groupId groupName:(NSString *)groupName;

///更新Groups表中avatar(更换群头像)
- (BOOL)updateGroup:(NSInteger)groupId avatar:(NSString *)avatar;

///更新Groups表(更换群头像和群名称)
- (BOOL)updateGroupInfoWithDictionary:(NSDictionary *)dictionary;

///更新GroupUsers表中的note(群昵称)
- (BOOL)updateGroupUsersNote:(NSInteger)groupId userId:(NSInteger)userId note:(NSString *)note;

///更新MyGroup表中isTop或者isBother
- (BOOL)updateMyGroup:(NSMutableDictionary *)dataDic;

///更新Friends表中isTop或者isBother
- (BOOL)updateFriends:(NSMutableDictionary *)dataDic;

///更新Friends表中的remark
- (BOOL)updateFriendsSingWithLoginUserId:(NSInteger)loginId friendId:(NSInteger)friendId remarkName:(NSString *)remarkName;

///更新Friends表中的enable(删除好友)
- (BOOL)updateFriendsEnableWithLoginUserId:(NSInteger)loginId friendId:(NSInteger)friendId;

///更新ChatList表中unreadcount
- (void)updateUnReadFromChatListWithLoginUserId:(NSInteger)loginUserId userId:(NSInteger)userId chatType:(NSInteger)chatType;

///更新ChatList表中的enable(删除聊天列表消息)
- (void)updateChatList:(NSMutableArray *)dataArray;

///更新User表中avatar(更换头像)
- (BOOL)updateUserWithUserId:(NSInteger)userId avatar:(NSString *)avatar;

///更新User表中nickName(更改昵称)
- (BOOL)updateUserWithUserId:(NSInteger)userId nickName:(NSString *)nickName;

///更新User表中sex(更改性别)
- (BOOL)updateUserWithUserId:(NSInteger)userId sex:(NSString *)sex;

//更新User表中sigNature(更改个性签名)
- (BOOL)updateUserWithUserId:(NSInteger)userId sigNature:(NSString *)sigNature;

//更新User表和Friends表中enable(是否关注应用号)
- (BOOL)updateUserAndFriendsWithUserId:(NSInteger)userId enable:(NSInteger)enable;

///更新User表中的信息
- (BOOL)updateUserInfoWithUserInfoDic:(NSDictionary *)userDic;
///更新friends表
- (BOOL)updateFriendsInfoWithDic:(NSDictionary *)userDic;

///存cell的高度
- (void)saveCellHeightWithMsgID:(NSString *)msgID cellHeight:(NSString *)height;

///取cell高度
- (NSString *)selectCellHeightWithMsgID:(NSString *)msgID;

///根据loginUserId和userId查询NewFriend数据
- (NSMutableDictionary *)selectNewFriendInfro:(NSInteger)loginUserId userId:(NSInteger)userId;

///根据loginUserId查询NewFriend中所有state为0的userId
- (NSMutableArray *)selectNewFriendWithLoginUserId:(NSInteger)loginUserId;

///根据groupId查询MyGroup表中的信息
- (NSMutableArray *)selectMyGroupInfoWithGroupId:(NSInteger)groupId loginUserId:(NSInteger)loginUserId;

///根据groupId和loginUserId查询MyGroup、Groups和GroupUsers表中的信息
- (NSMutableDictionary *)selectMyGroupAndGrooupWithGroupId:(NSInteger)groupId loginUserId:(NSInteger)loginUserId;

///查询loginUserId对应的state和用户信息
- (NSMutableArray *)selectStateAndUserInfor:(NSInteger)loginUserId;

///查询loginUserId对应的Friends中和User中信息
- (NSMutableArray *)selectFriendInfor:(NSInteger)loginUserId withType:(NSUInteger)type;

///查询userId对应的User表中信息
- (NSMutableDictionary *)selectUserInfor:(NSInteger)userId;

- (void)selectUser:(NSInteger)userId;

///查询userId对应的isTop、isBother、avatar和name
- (NSMutableDictionary *)selectUserInfor:(NSInteger)loginUserId userId:(NSInteger)userId;

///查询groupId对应的群组成员的全部信息
- (NSMutableArray *)selectGroupUsersInfor:(NSInteger)groupId;

///查询群组中个人昵称
- (NSString *)selectSingleGroupUsersInfo:(NSInteger)groupId userId:(NSInteger)userId loginUserId:(NSInteger)loginUserId;

///查询groupId 和 loginUserId对应的群组成员的全部信息
- (NSMutableArray *)selectGroupUsersInfor:(NSInteger)groupId loginUserId:(NSInteger)loginUserId;

///查询loginUserId对应的MyGroup表中的的全部信息
- (NSMutableArray *)selectMyGroupInfor:(NSInteger)loginUserId;

///查询groupId对应的MyGroup表中的的全部信息
- (NSMutableArray *)selectMyGroupInforWithGroupId:(NSInteger)groupId;

///查询loginUserId对应的Groups表中的全部信息
- (NSMutableArray *)selectGroupInfor:(NSInteger)loginUserId;

///查询loginUserId和userId对应的Friends表中的全部信息
- (NSMutableArray *)selectFrindsWithLoginUserId:(NSInteger)loginUserId userId:(int)userId;

///读取消息列表信息
- (NSMutableDictionary *)dataFromChatListWithUserId:(NSInteger)loginUserId;

///根据groupId查询Groups表中的信息
- (NSMutableArray *)selectGroupInfoWithGroupId:(NSInteger)groupId;

/// 向 Message表中插入 <IMStructMessage *> message
- (void)saveMessageToMessage:(IMStructMessage *)message;

/// 单聊 从Message表 中读取 信息 ，返回按时间排好序的数组(升序) cunt为 查询的条数 offset页数
- (NSMutableArray *)selectMessageFromMessage:(NSInteger)fromUserID withtoUserID:(NSInteger)toUserID messageCount:(NSInteger)count messageId:(NSString *)messageId;
//- (NSMutableArray *)selectMessageFromMessage:(int)fromUserID withtoUserID:(int)toUserID messageCount:(int)count offset:(int)offset;

/// 群聊 从Message表中读取信息
- (NSMutableArray *)selectMessageToGroupID:(NSInteger)toGroupID messageCount:(NSInteger)count withMessageId:(NSString *)messageId;
//- (NSMutableArray *)selectMessageToGroupID:(int)toGroupID messageCount:(int)count offset:(int)offset;

/// 从Message表中删除信息（更改下状态）
- (void)deleteMessageFromMessage:(IMStructMessage *)message;

/// 从Message表中查询未读信息
- (NSMutableArray *)selectUnreadMessageFromMessage:(NSInteger)fromUserID withtoUserID:(NSInteger)toUserID;

///根据userId从user表中获取userType
- (NSInteger)selectUserTypeFromUserWith:(NSInteger)userId;

///根据公众号id查询公众号信息
- (NSMutableArray *)selectServiceAndApplicationInfoWithUserId:(NSInteger)userId;

///获取本人头像
- (NSString *)myAvatar;
///获取备注
- (NSString *)remarkNameFromFriendsByuserID:(NSString *)userID;

/// 将 申请人 存储到 申请加入群人员的表 中 (群组 id，申请人id， 收到申请的时间)
- (BOOL)saveJoinGroupUserToGroupNoticeWithGroupId:(NSInteger)groupId userId:(NSInteger)userId receivedJoinRequestTime:(NSString *)receivedJoinRequestTime;

/// 从存储 申请加入群人员的表 中查询是否存在 (群组 id，申请人id)
- (NSMutableArray *)selectSavedJoinGroupUserFromGroupNoticeWithGroupId:(NSInteger)groupId userId:(NSInteger)userId;

/// 查询 GroupNotice 表中的所有用户
- (NSMutableArray *)selectAllJoinGroupUserFromGroupNotice;

/// 同意加入群之后 往 GroupUsers表中插 同时更新 GroupNotice
- (BOOL)agreedJoinGroupUpdateGroupUsersWithGroupId:(NSInteger)groupId userId:(NSInteger)userId;

/// 修改groupusers表中的groupUserType
- (BOOL)updateGroupUsersGroupUserTypeWithGroupId:(NSInteger)groupId userId:(NSInteger)userId groupUserType:(NSInteger)groupUserType;

/// 将 GroupNotice 表中的标记为已读
- (BOOL)updateGroupNoticeToAllRead;

/// 更改chatList表中的信息，如果enable为0
- (BOOL)updateChatListEnableToZeroWithLoginUserId:(NSInteger)userId toUserId:(NSInteger)toUserId;

/// 添加群成员的时候，如果本地有这个group就把enable设置为1
- (BOOL)updateMyGroupAndGroupEnableToOneWithGroupId:(NSInteger)groupId andLoginUserId:(NSInteger)loginUserId;

/// 删除群成员更新 GroupNotice 表
- (BOOL)whenDeleteGroupUserUpdateGroupNoticeWithGroupId:(NSInteger)groupId andUserId:(NSInteger)userId;

- (IMStructMessage *)getUserLastMessage:(NSString *)userid;

/**
 查询某几个群成员的详细信息
 
 @param groupId 群Id
 @param membersIdArray 存放群成员Id的数组 membersIdArray内容为 [{@"memberId" : @""}, {@"memberId" : @""}, {@"memberId" : @""}...]
 @return 返回 查询到的 群成员
 */
- (NSMutableArray *)selectGroupMembersDetailsWithGroupId:(NSString *)groupId membersIdArray:(NSMutableArray *)membersIdArray;

/**
 根据消息ID 来查找某条消息
 
 @param messageID 消息ID
 @return 查找到就返回该条消息，查找不到就返回空
 */
- (IMStructMessage *)queryMessageWithMessageID:(NSString *)messageID;

/**
 更新消息内容
 
 @param messageID 消息ID
 @param message 消息内容
 */
- (void)updateMessageWithMessageId:(NSString *)messageID messageStr:(NSString *)message;

/**
 查询所有群成员的nickname与Id
 
 @param groupId 群Id
 @param loginUserId 自己的ID
 @return 返回所有群成员
 */
- (NSMutableArray *)selectGroupUsersNickNameAndIdWithGroupId:(NSInteger)groupId loginUserId:(NSInteger)loginUserId;


- (NSMutableArray *)selectGroupUsersInforss:(NSInteger)groupId loginUserId:(NSInteger)loginUserId;

///获取群成员数量
- (NSInteger)countWithGroupID:(int)groupID ;

///存用户钱包地址跟公钥
- (void)updateUserAddressAndPublicKeyWithUserID:(NSString *)userID address:(NSString *)address publicKey:(NSString *)publicKey comPublicKey:(NSString *)comPublicKey;
///获取钱包地址
-(NSString *)selectEthAddressWith:(NSString *)userID;
- (NSMutableArray *)queryPublicInfo:(NSInteger)loginUserId;








///获取通讯录列表
-(NSMutableArray *)selectFriendsList;
@end
