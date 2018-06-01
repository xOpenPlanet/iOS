//
//  EFChatHttpManager.h
//  ESPChatComps
//
//  Created by zgb on 16/8/11.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFChatHttpManager : NSObject

///网页登录
- (void)HttpReauestForWebLogin:(NSString *) url success: (void (^) (id responseObject))success failure:(void(^)(NSString *error)) failure;
///注册接口
- (void)HttpRequestForRegisterWithUserId:(NSString *)userId userName:(NSString *)username userPassword:(NSString *)password success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
///修改密码接口
- (void)HttpRequestForChangePassWordWithUserId:(NSString *)userId passWord:(NSString *)passWord newPassword:(NSString *)newPassword success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
///登陆接口
- (void)HttpRequestForLoginWithUserId:(NSString *)userId userPassword:(NSString *)password success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
///同步公众号的http服务
- (void)HttpRequestForGettingPublicListUserId:(NSString *)userId userPassword:(NSString *)password success:(void (^)(id))success failure:(void (^)(NSString *))failure;
//- (void)httpRequestForGettingPublicListByUserId:(NSString *)userId userPassword:(NSString *)password success:(void (^)(id))success failure:(void (^)(NSString *))failure;
///异步搜索公众号信息
- (void)HttpRequestForGettingSearchPublicListUserId:(NSString *)userId userPassword:(NSString *)password keyWord:(NSString *)keywords success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;
///同步搜索应用号信息
- (void)synchroHttpRequestForGettingSearchPublicListUserId:(NSString *)userId userPassword:(NSString *)password keyWord:(NSString *)keywords success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;
///关注公众号
//- (void)HttpRequestForGettingConcernPublicInfoUserId:(NSString *)publicId userPassword:(NSString *)publicPwd addUserId:(NSString *)userId success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
- (void)HttpRequestForGettingConcernPublicInfoUserId:(NSString *)userID WithSserPassword:(NSString *)userPassword WithPublicId:(NSString *)publicId success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
//取消关注公众号
-(void)HttpRequestForCancelConcernPublicInfoUserId:(NSString *)userid passWord:(NSString *)password publicId:(NSString *)publicid success:(void (^)(id response))success failure:(void (^)(NSString * error))failure;
//应用号升级检测
-(void)HttpRequestForCheckApplicationVersionWithAppID:(NSString *)applicationID success:(void (^)(id response))success failure:(void (^)(NSString * error))failure;
///发送好友申请的http服务
- (void)HttpRequestForApplyingAddFriendWithUserId:(NSString *)userId userPassword:(NSString *)password friendUserId:(NSString *)friendUserId success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
/// 查找好友申请信息的http服务
- (void)HttpRequestForGettingOtherUserInfoWithFriendId:(NSString *)friendId success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///好友申请回执的http服务（点击接受）
- (void)HttpRequestForReceivingReceiptWithUserId:(NSString *)userId userPassword:(NSString *)password friendUserId:(NSString *)friendUserId success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///同步通讯录的http服务
- (void)HttpRequestForGettingAddressListUserId:(NSString *)userId userPassword:(NSString *)password success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///获取群聊列表的http服务
- (void)HttpRequestForGettingGroupListWithUserId:(NSString *)userId userPassword:(NSString *)password success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
///更改群组信息http服务
- (void)HttpRequestForUpGroupInfoWithUserId:(NSString *)userId userPassword:(NSString *)password groupId:(NSString *)groudId grouoAvatar:(NSString *)avatar success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///创建群组的http服务
- (void)HttpRequestForCreateGroupChatWithGroupName:(NSString *)groupName userId:(NSString *)userId userPassword:(NSString *)password success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///添加群成员的http服务
- (void)HttpRequestForAddUserToGroupWithGroupId:(NSString *)groudId userId:(NSString *)userId userPassword:(NSString *)password addUserId:(NSString *)addUserId success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///修改群组名的http服务
- (void)HttpRequestForUpGroupNameWithUserId:(NSString *)userId userPassword:(NSString *)password groupId:(NSString *)groudId groupName:(NSString *)groupName success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///退群的http服务
- (void)HttpRequestForQuitTheGroupWithUserId:(NSString *)userId userPassword:(NSString *)password groupId:(NSString *)groudId success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///获取群成员信息
- (void)HttpRequestForGetGroupPersonUserId:(NSString *)userId userPassword:(NSString *)password groupId:(NSString *)groudId success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///获取群组信息
- (void)HttpRequestForGetGroupInfoWithGroupId:(NSString *)groupId userId:(NSString *)userId userPassword:(NSString *)password success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///根据群组名称搜索群组
- (void)httpRequestForSearchingGroupWithUserId:(NSString *)userId userPassword:(NSString *)password keyWord:(NSString *)keyWord success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;

///移除群成员
- (void)HttpRequestForDeleteGroupUserWithUserId:(NSString *)userId userPassword:(NSString *)password groupId:(NSString *)groudId deleteUserId:(NSString *)deteleId success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///更换头像
- (void)HttpRequestForChangeHeadImageWithUserId:(NSString *)userId userPassword:(NSString *)password headImageURL:(NSString *)headImageURL success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///更改昵称
- (void)HttpRequestForChangeHeadImageWithUserId:(NSString *)userId userPassword:(NSString *)password nickName:(NSString *)nickName success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///更改性别
- (void)HttpRequestForChangeHeadImageWithUserId:(NSString *)userId userPassword:(NSString *)password sex:(NSString *)sex success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///更改个性签名
- (void)HttpRequestForChangeHeadImageWithUserId:(NSString *)userId userPassword:(NSString *)password sigNature:(NSString *)sigNature success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///修改备注
- (void)HttpRequestForRemarkFriendNameWithUserId:(NSString *)userId userPassword:(NSString *)password friendId:(NSString *)friendId remarkName:(NSString *)note success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///删除好友
- (void)HttpRequestForDeleteFriendWithUserId:(NSString *)userId userPassword:(NSString *)password friendId:(NSString *)friendId success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///修改自己的群昵称
- (void)HttpRequestForUpdataOwnRemarkInGroupWithUserId:(NSString *)userId userPassword:(NSString *)password groupId:(NSString *)groudId ownRemark:(NSString *)ownRemark success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///修改别人的群昵称
- (void)HttpRequestForUpdataOtherRemarkInGroupWithUserId:(NSString *)userId userPassword:(NSString *)password groupId:(NSString *)groudId otherUserId:(NSString *)otherUserId otherRemark:(NSString *)otherRemark success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///发送离线消息
- (void)HttpRequestForOfflineWithUserId:(NSString *)userId userPassword:(NSString *)password deviceToken:(NSString *)token badge:(NSString *)badge deviceId:(NSString *)deviceId apnsPush:(NSString *)apnsPush;

///加入某个群组
- (void)httpRequestForJoinGroupWithUserId:(NSString *)userId userPassword:(NSString *)password groupId:(NSString *)groupId success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;

///设置群管理员
- (void)httpRequestForSetGroupManagerWithUserId:(NSString *)userId userPassword:(NSString *)password groupId:(NSString *)groupId otherUserId:(NSString *)otherUserId success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;

///取消群管理员身份
- (void)httpRequestForCancelGroupManagerWithUserId:(NSString *)userId userPassword:(NSString *)password groupId:(NSString *)groupId otherUserId:(NSString *)otherUserId success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;

///搜索好友信息
- (void)HttpRequestForSearchFriendInfoWithUserId:(NSString *)userId userPassword:(NSString *)password keyWord:(NSString *)keywords success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;

//任务列表信息
- (void)HttpRequestForTaskList: (NSString *) api withParams:(NSString *)paramas success: (void (^) (id responseObject))success failure:(void(^)(NSString *error)) failure;

- (void)HttpReauestForTaskList:(NSString *) url success: (void (^) (id responseObject))success failure:(void(^)(NSString *error)) failure;
//设置验证口令
- (void)HttpRequestForPwdSetting: (NSString *) api withParams:(NSString *)paramas success: (void (^) (id responseObject))success failure:(void(^)(NSString *error)) failure;
///查询群组的办公地点
- (void)HttpRequestForSearchGroupOfficeAddress:(NSString *)groupId success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;

///增加群组的办公地点
- (void)HttpRequestForAddGroupOfficeAddress:(NSString *)groupId  longitude:(NSString *)longitude latitude:(NSString *)latitude positionName:(NSString *)positionName shortpositionname:(NSString *)shortpositionname success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;

///删除群组的办公地点
- (void)HttpRequestForDeleteGroupOfficeAddress:(NSString *)addressID success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;

///获取群组图标设置信息
- (void)HttpRequestForSearchGroupIconConfigInfoWithUserId:(NSString *)userId userPassword:(NSString *)password groupId:(NSString *)groupId configKey:(NSString *)configKey success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;

///解散群组
-(void)HttpRequestForDissolveGroupWithUserID:(NSString *)userId withSserPassword:(NSString *)passWord withGroupId:(NSString *)groupId success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;
///获取共享根节点的组织机构
- (void)HttpRequestForRootNodeOrgWithUserId:(NSString *)userId success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;

///获取共享子节点的组织机构
- (void)HttpRequestForNodeOrgWithUserId:(NSString *)userId bh:(NSString *)bh mx:(NSString *)mx js:(NSString *)js type:(NSString *)type success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;

///人脸识别相关
- (void)HttpReauestForVeriface:(NSString *) url success: (void (^) (id responseObject))success failure:(void(^)(NSString *error)) failure;

//获取摄像头列表
- (void)HttpRequestForCameraList: (NSString *) api withParams:(NSString *)paramas success: (void (^) (id responseObject))success failure:(void(^)(NSString *error)) failure;

//获取流水数据
- (void)HttpReauestForDiscernList:(NSString *) url success: (void (^) (id responseObject))success failure:(void(^)(NSString *error)) failure;

///获取钱包地址和公钥
-(void)HttpRequestForEthAddressAndEthPublicAddressWithOtherUser:(NSString *)user success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;

///开放星球扫码登陆
-(void)HttpRequestForScanloginWithParameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;

-(void)HttpRequestForVersionCheckWithAppID:(NSString *)AppID success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;

///开放星球获取通讯录列表
-(void)HttpRequestForAddresslistWithToken:(NSString *)token success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;
///开放星球搜索好友
- (void)opHttpRequestForSearchFriendInfoWithToken:(NSString *)token keyWord:(NSString *)keywords success:(void (^)(id responseObject))success failure:(void(^)(NSString *error))failure;

///开放星球获取群成员信息
- (void)opHttpRequestForGetGroupPersonWithToken:(NSString *)token userId:(NSString *)userId userPassword:(NSString *)password groupId:(NSString *)groudId success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///欢迎消息
- (void)opHttpRequestForLoginMessageWithToken:(NSString *)token success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

///获取公众号列表
- (void)opHttpRequestForPublicListWithToken:(NSString *)token success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;
@end
