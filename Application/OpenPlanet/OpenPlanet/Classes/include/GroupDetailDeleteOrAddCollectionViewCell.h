//
//  GroupDetailDeleteOrAddCollectionViewCell.h
//  ESPChatComps
//
//  Created by 于仁汇 on 16/12/16.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupDetailDeleteOrAddCollectionViewCell : UICollectionViewCell

/// 赋值 @"add" 添加， @"delete" 删除
- (void)infoForCell:(NSString *)string;

@end
