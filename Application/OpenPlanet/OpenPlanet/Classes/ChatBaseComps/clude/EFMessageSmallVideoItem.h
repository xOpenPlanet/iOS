//
//  EFMessageSmallVideoItem.h
//  ESPChatComps
//
//  Created by 于仁汇 on 16/7/5.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFMessageItem.h"

@class EFMessageSmallVideoItem;
@protocol EFMessageSmallVideoItemDelegate <NSObject>

- (void)checkSmallVideoReturnKey:(EFMessageSmallVideoItem *)item;

@end

@interface EFMessageSmallVideoItem : NSObject<JFMessageItem>

@property (nonatomic, weak) id<EFMessageSmallVideoItemDelegate> delegate;

/// 展示进度
- (void)changeShadeView:(NSString *)percent;

@end
