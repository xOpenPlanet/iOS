//
//  EFXHNavigationController.h
//  IOSMobileManager
//
//  Created by 虎 谢 on 2017/6/22.
//  Copyright © 2017年 JavorFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBadgeView.h"
@interface EFXHNavigationController : UINavigationController<IBadgeView,UIGestureRecognizerDelegate>

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController;

@end
