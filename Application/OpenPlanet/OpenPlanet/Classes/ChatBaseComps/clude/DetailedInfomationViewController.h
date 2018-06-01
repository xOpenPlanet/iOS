//
//  DetailedInfomationViewController.h
//  ESPChatComps
//
//  Update by YU on 18/3/7.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

/*
 从通讯录列表点击关注的应用号，跳转出来的展示该应用号基本信息的界面
 */

#import <UIKit/UIKit.h>
#import "PersonModel.h"
@interface DetailedInfomationViewController : UIViewController

@property (nonatomic,strong) PersonModel *personModel;
-(instancetype)initWithUserId:(NSInteger)userId isSendCancel:(BOOL)isSendCancel;
@end
