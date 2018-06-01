//
//  SwitchTableViewCell.h
//  ESPChatComps
//
//  Created by 陈海鹏 on 16/8/17.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchTableViewCell;

@protocol switchCellDetegate <NSObject>

- (void)returnClickSwitch:(SwitchTableViewCell *)cell;

@end

@interface SwitchTableViewCell : UITableViewCell

///标题
@property (nonatomic,copy) NSString   *textString;
///switch开关
@property (nonatomic,strong) UISwitch *switchButton;
@property (nonatomic,strong) NSDictionary  *switchDictionary;
@property (nonatomic,strong) NSIndexPath   *switchIndex;

@property (nonatomic,weak) id<switchCellDetegate>delegate;

@end
