//
//  ViewShowLoadingObj.m
//  OSPMobile
//
//  Created by 于仁汇 on 2017/9/12.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import "ViewShowLoadingObj.h"
#import "MBProgressHUD.h"

@implementation ViewShowLoadingObj

+ (void)showHudView:(NSString *)text {
    [ViewShowLoadingObj viewShowHudView:text forView:[UIApplication sharedApplication].keyWindow];
}

+ (void)hiddenHudViewLoading {
    [ViewShowLoadingObj hiddenHudForView:[UIApplication sharedApplication].keyWindow];
}

+ (void)viewShowHudView:(NSString *)text forView:(UIView *)targetView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    [hud show:YES];
}

+ (void)hiddenHudForView:(UIView *)targetView {
    [MBProgressHUD hideHUDForView:targetView animated:YES];
}



@end
