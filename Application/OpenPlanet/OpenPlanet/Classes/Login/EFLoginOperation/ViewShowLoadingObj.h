//
//  ViewShowLoadingObj.h
//  OSPMobile
//
//  Created by 于仁汇 on 2017/9/12.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewShowLoadingObj : NSObject

/// 展示
+ (void)showHudView:(NSString *)text;

/// 隐藏
+ (void)hiddenHudViewLoading;

@end
