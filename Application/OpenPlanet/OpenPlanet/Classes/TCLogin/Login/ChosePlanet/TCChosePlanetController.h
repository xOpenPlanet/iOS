//
//  TCChosePlanetController.h
//  
//
//  Created by YRH on 2018/4/20.
//  Copyright © 2018年 YRH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCChosePlanetController : UIViewController

/// 地区编号
@property (copy, nonatomic) NSString *areaCode;
/// 手机号
@property (copy, nonatomic) NSString *phone;
/// 邀请码
@property (copy, nonatomic) NSString *inviteCode;

@end
