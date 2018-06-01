//
//  EFAnimationOperationView.h
//  ESPChatComps
//
//  Created by 虎 谢 on 2018/4/2.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatAnimationView.h"

@interface EFAnimationOperationView : UIView<ChatAnimationViewDelegate>

@property (nonatomic, readonly) ChatAnimationView *animationView;

@end
