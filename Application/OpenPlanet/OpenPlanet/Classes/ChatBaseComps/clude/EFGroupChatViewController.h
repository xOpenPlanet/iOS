//
//  EFGroupChatViewController.h
//  ESPChatComps
//
//  Created by 虎 谢 on 2016/12/22.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import "EFChatViewController.h"

@interface EFGroupChatViewController : EFChatViewController
//群组信息
@property(nonatomic, strong)  NSDictionary      *groupMessageDictionary;
//群组图标配置信息
@property(nonatomic, strong)  NSMutableArray    *groupMenuArray;
//群成员个数
@property(nonatomic,strong)   NSString          *groupCount;
//详情按钮
@property(nonatomic,strong)   UIBarButtonItem   *detailItem;
@end
