//
//  TCInputInviteCodeController.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/22.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//  2.输入邀请码(新用户)

#import <UIKit/UIKit.h>

@interface TCInputInviteCodeController : UIViewController

/// 地区编号
@property (copy, nonatomic) NSString *areaCode;
/// 手机号
@property (copy, nonatomic) NSString *phone;

@end
