//
//  LoginWebAlertViewController.h
//  ESPChatComps
//
//  Created by YRH on 2017/12/4.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoginBlock)(void);

@interface LoginWebAlertViewController : UIViewController

@property (nonatomic, copy) NSDictionary *scanDic;

@end
