//
//  TCAddressDetailCell.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/15.
//  Copyright © 2018年 wsl. All rights reserved.
//  联系人电话Cell

#import <UIKit/UIKit.h>

@interface TCAddressDetailCell : UITableViewCell


/**
 赋值联系人电话号码

 @param phone 电话号码
 @param phoneTip 号码标签
 */
- (void)cellWithPhone:(NSString *)phone phoneTip:(NSString *)phoneTip;

@end
