//
//  PersonModel.h
//  FriendSearch
//
//  Created by 吴鹏 on 16/4/9.
//  Copyright © 2016年 Caoyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject

@property(nonatomic,strong)NSString *label_main;//详情界面中左侧label
@property(nonatomic,strong)NSString *label_detail;//详情界面中第二个label（电话）
@property(nonatomic,assign)NSInteger state;//0--添加 1--等待验证
@property(nonatomic,strong)NSString *header;
@property(nonatomic,assign)BOOL isDelete;//是否删除

/// avatar
@property (nonatomic, copy) NSString *avatar;
/// 邮箱
@property (nonatomic, copy) NSString *email;
/// 电话号码
@property (nonatomic, copy) NSString *mobilePhone;
/// 昵称
@property (nonatomic, copy) NSString *nickName;
/// 电话
@property (nonatomic, copy) NSString *phone;
/// 性别
@property (nonatomic, copy) NSString *sex;
/// 用户Id
@property (nonatomic, assign) int userId;
/// 用户名
@property (nonatomic, copy) NSString *userName;
/// 类型
@property (nonatomic, assign) int userType;
//
@property (nonatomic, assign) int loginUserId;
///个性签名
@property (nonatomic,copy) NSString *sign;
///备注名
@property (nonatomic,copy) NSString *remarkName;
///伪昵称(通讯录排序用)
@property (nonatomic,copy) NSString *addressName;
///群昵称
@property (nonatomic,copy) NSString *groupNote;

@property (nonatomic,copy) NSString *ethAddress;

@property (nonatomic,copy) NSString *ethPublicKey;

@property (nonatomic,copy) NSString *comPublicKey;

@property (nonatomic, assign) int isTop;

@property (nonatomic, copy) NSString *isBother;

@property (nonatomic, assign) int remark;

@property (nonatomic, assign) int isImportent;
//是否关注公众号
@property (nonatomic, assign) int enable;
/// 该用户在群组中的 身份
@property (nonatomic, assign) int groupUserType;

@end
