//
//  LoginViewController.h
//  YTAutoLayout
//
//  Created by fly on 14/12/12.
//  Copyright (c) 2014年 fly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Extension.h"
#import "LoginView.h"
#import "EFLoginManager.h"
@interface LoginViewController : UIViewController 

@property(nonatomic, weak)      LoginView           *loginView;
@property(nonatomic, strong)    NSString            *userName;
@property(nonatomic, strong)    NSString            *userPwd;
@property(nonatomic, strong)    NSMutableArray      *controllerModels;
@property(nonatomic, strong)    EFLoginManager      *loginManager;
@property(nonatomic, weak)      UISwitch            *autoLogin;
@property(nonatomic, weak)      UISwitch            *savePwd;
@property(nonatomic,strong)     NSDictionary        *mapDict;
@property(nonatomic,strong)     NSString            *updateURL;

- (void)createWebView;

@end
