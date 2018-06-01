//
//  ViewControllerAnimatedTransition.h
//  ESPChatComps
//
//  Created by 于仁汇 on 2017/8/14.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

/*
 自定义 跳转样式类
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PresentOneTransitionTypePresent,
    PresentOneTransitionTypeDismiss,
} PageCoverTransitionType;

@interface ViewControllerAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithType:(PageCoverTransitionType)type;
- (instancetype)initWithTransitionType:(PageCoverTransitionType)type;

@end
