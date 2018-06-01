//
//  JFTransferDetailsController.h
//  ESPChatComps
//
//  Created by YRH on 2018/4/27.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

/*
 转账详情界面
 */

#import <UIKit/UIKit.h>
#import "IMStructMessage.h"

@interface JFTransferDetailsController : UIViewController


@property (nonatomic, strong) IMStructMessage *message;
/**
 转账详情json字符串
 */
//@property (nonatomic, copy) NSString *transferDetailsJsonString;

@end
