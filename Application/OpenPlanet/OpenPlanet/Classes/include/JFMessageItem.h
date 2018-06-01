//
//  JFMessageItem.h
//  ESPChatComps
//
//  Created by Javor on 16/4/13.
//  Copyright (c) 2016年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IMStructMessage.h"

@protocol JFMessageItem <NSObject>

@property(nonatomic, strong) IMStructMessage *message;
@property(nonatomic, assign) BOOL isInUse;

///显示内容View
- (UIView *)messageView;
///显示内容View的Size
- (CGSize)messageViewSize;

@end
