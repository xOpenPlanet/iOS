//
//  OfficialAccountButton.h
//  ESPChatComps
//
//  Created by 吴鹏 on 16/7/21.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfficialAccountModel.h"

@interface OfficialAccountButton : UIButton

///是否有下级
@property (nonatomic, assign)BOOL isSingle;
///记录自己的信息（包括自己id、父id和携带信息）
@property (nonatomic, strong)OfficialAccountModel *model;

- (instancetype)initWithBackgroundColor:(UIColor *)color;

@end
