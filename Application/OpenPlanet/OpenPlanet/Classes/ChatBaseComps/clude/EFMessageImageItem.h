//
//  EFMessageImageItem.h
//  ESPChatComps
//
//  Created by zgb on 16/7/1.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFMessageItem.h"

@class EFMessageImageItem;
@protocol EFMessageImageItemDelegate <NSObject>

- (void)checkImageReturnKey:(EFMessageImageItem *)item;

@end

@interface EFMessageImageItem : NSObject<JFMessageItem>

@property (nonatomic, weak) id<EFMessageImageItemDelegate> delegate;

/// 更新进度
- (void)changeShadeView:(NSString *)percent;

@end
