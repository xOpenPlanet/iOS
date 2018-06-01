//
//  IIMStruct.h
//  IOSESPBase
//
//  Created by Javor on 16/4/9.
//  Copyright (c) 2016年 JavorFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IIMStruct <NSObject>

typedef enum{
    /**非离线*/
    offlineType_0 = (Byte)0,
    /**离线*/
    offlineType_1 = (Byte)1,
}offlineType;

typedef enum{
    /**心跳*/
    messageType_0 = (Byte)0,
    /**首次登录*/
    messageType_1 = (Byte)1,
    /**点对点消息*/
    messageType_2 = (Byte)2,
    /**回执*/
    messageType_3 = (Byte)3,
}messageType;

typedef enum{
    /**个人到个人*/
    postType_0 = (Byte)0,
    /**个人到群组*/
    postType_1 = (Byte)1,
    /**应用号到所有关注人*/
    postType_2 = (Byte)2,
}postType;

typedef enum{
    /**文本*/
    subtype_text           = (short)0,
    /**图片*/
    subtype_image          = (short)1,
    /**语音*/
    subtype_voice          = (short)2,
    /**小视频*/
    subtype_smallVideo     = (short)3,
    /**拍摄视频*/
    subtype_video          = (short)4,
    /**文件*/
    subtype_file           = (short)5,
    /**文本(新) json格式*/
    subtype_json_text      = (short)6,
    /**动画*/
    subtype_animation      = (short)7,
    /**转账*/
    subtype_transfer       = (short)8,
    /**密信*/
    subtype_secretText     = (short)20,
    /**密图*/
    subtype_secretImage     = (short)21,
    /**密件*/
    subtype_secretFile     = (short)22,
    /**网页*/
    subtype_webItem         = (short)24,
    /**应用号单个信息*/
    subtype_appSingle       = (short)23,
    /**表单*/
    subtype_form           = (short)31,
    /**表单原生*/
    subtype_form_native    = (short)32,
    /**公众号*/
    subtype_officalAccount = (short)41,
    /**名片*/
    subtype_callingCard    = (short)42,
    /**消费凭证*/
    subtype_payCard        = (short)43,
    /**任务*/
    subtype_task           = (short)44,
    /**阅后即焚文本*/
    subtype_bornText       = (short)50,
    /**阅后即焚图片*/
    subtype_bornImage      = (short)51,
    /**阅后即焚语音*/
    subtype_bornVoice      = (short)52,
    /**阅后即焚小视频*/
    subtype_bornSmallVideo = (short)53,
    /**阅后即焚拍摄视频*/
    subtype_bornVideo      = (short)54,
    /**位置*/
    subtype_location       = (short)55,
    /**费用报销*/
    subtype_feiyongbaoxiao = (short)56,
    /**oa*/
    subtype_oa             = (short)57,
    /**命令类型的消息（例如：作废单据）*/
    subtype_command        = (short)60,
    /**web*/
    subtype_web            = (short)61,
    /**通用*/
    subtype_common         = (short)62,
    /**通用带背景大图*/
    subtype_commonImage    = (short)63,
    //65
    /**空间通知类型*/
    subtype_mZoneNotification = (short) 80,
    /**撤回的消息类型*/
    subtype_recallMessage  = (short)98,
    /**用户自定义*/
    subtype_custome        = (short)99,
    /**系统消息*/
    subtype_system         = (short)100,
    /**已送达*/
    subtype_send           = (short)101,
    /**已读*/
    subtype_read           = (short)102,
    /**直播、点播系统消息唯一指定id*/
    subtype_liveSystemMsg  = (short)251,
    /**应用号主数据更新*/
    subtype_masterdata     = (short) 301,
    /**应用号号资源更新*/
    subtype_officalAccountRes = (short) 302,
    /**app更新*/
    subtype_App            = (short) 303,
    /**app资源文件更新*/
    subtype_AppRes         = (short) 304,
}subtype;

///版本号
@property(nonatomic, assign) short      version;
///消息类型     0:心跳  1:首次登录  2:点对点消息  3:回执
@property(nonatomic, assign) Byte       messageType;
///消息长度
@property(nonatomic, assign) int        messageLength;
///客户端GUID
@property(nonatomic, copy)   NSString   *clientID;
///来源用户ID
@property(nonatomic, assign) int        fromUserID;
///发送到用户ID
@property(nonatomic, assign) int        toUserID;
///消息ID
@property(nonatomic, assign) int        messageID;
///消息ID 消息唯一标识
@property(nonatomic, copy)   NSString   *messageIDString;
///消息时间
@property(nonatomic, assign) long long  time;
///服务器时间
@property(nonatomic, assign) long long  serverTime;
///消息投递分类   0:个人到个人  1:个人到群组
@property(nonatomic, assign) Byte       postType;
///消息子类型     0:文本  1:图片  2:音频  3:视频  99:用户自定义
@property(nonatomic, assign) short      subtype;
///消息内容长度
@property(nonatomic, assign) short      messageContentLength;
///消息内容
@property(nonatomic, copy)   NSData     *body;
@property(nonatomic, copy)   NSString   *message;
///回执类型 0:送达 1:已读
@property(nonatomic, assign) Byte       ackType;
///是否有parentID
@property(nonatomic, assign) Byte       isHavePMsgId;
///父消息ID
@property(nonatomic, copy)   NSString   *pMsgId;
///父用户ID
@property(nonatomic, assign) int        pUserId;
///离线消息标志
@property(nonatomic, assign) Byte       offline;
/// 积分大类
@property(nonatomic, assign) Byte       integralType;
///积分小类
@property(nonatomic, assign) Byte       integralSubtype;
///积分值
@property(nonatomic, assign) short      integral;

///最后一条消息的时间
@property(nonatomic, copy)   NSString   *lastMessageTime;

@property(nonatomic, copy)   NSString   *userID;
@property(nonatomic, copy)   NSDate     *localTime;
@property(nonatomic, copy)   NSString   *userNickName;
@property(nonatomic, copy)   NSString   *userAvatar;


- (Byte *)toByteArray;
- (NSData *)toData;
- (void)toStruct:(NSData *)data;

@end
