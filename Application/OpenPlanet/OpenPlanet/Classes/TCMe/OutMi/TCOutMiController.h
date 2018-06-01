//
//  TCOutMiController.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/31.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCWalletModel.h"


typedef NS_ENUM(NSUInteger,TransferFromType) {
    /// 默认转账
    TransferTypeFromDefault,
    /// 聊天页面转账
    TransferTypeFromChat,
    /// 二维码转账
    TransferTypeFromQRCode,
};


@interface TCOutMiController : UIViewController


/// 进入类型
@property (assign, nonatomic) TransferFromType type;

/// TransferTypeFromChat类型使用
@property (strong, nonatomic) NSString *toUserId;

/// TransferTypeFromChat类型使用
@property (strong, nonatomic) NSDictionary *toAddressInfo;

@end
