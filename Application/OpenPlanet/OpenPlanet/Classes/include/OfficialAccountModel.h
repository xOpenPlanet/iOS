//
//  OfficialAccountModel.h
//  ESPChatComps
//
//  Created by 吴鹏 on 16/7/27.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfficialAccountModel : NSObject
///自己的id
@property (nonatomic, copy)NSString *selfId;
///父亲id
@property (nonatomic, copy)NSString *fatherId;
///跳转的urlString
@property (nonatomic, copy)NSString *urlString;

@end
