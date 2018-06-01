//
//  EFAppContentViewController.h
//  ESPChatComps
//
//  Created by 于仁汇 on 2017/8/16.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

/*
 应用号中每个界面控制器类
 */

#import <UIKit/UIKit.h>
#import "StubObject.h"

@interface EFAppContentViewController : UIViewController

@property (nonatomic, strong) StubObject *dataStub;
@property (nonatomic, copy) NSString *htmlpath;

@end
