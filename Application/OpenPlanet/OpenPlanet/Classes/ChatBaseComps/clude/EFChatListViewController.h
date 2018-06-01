//
//  EFChatListViewController.h
//  ESPChatComps
//
//  Created by Javor on 16/4/10.
//  Copyright (c) 2016年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFMessageManager.h"
#import "EFTableView.h"
//#import "EFLeftViewController.h"
#import "IBadgeView.h"
#import "EFExitObj.h"

@interface EFChatListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,JFMessageManagerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) EFTableView    *tableView;
///整个列表数据源
@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) NSString       *updateURL;

@property (nonatomic,assign)  BOOL           isConnectShow;
//应用号侧滑
//@property (nonatomic, strong) EFLeftViewController *leftVC;

@property(nonatomic, weak) id<IBadgeView>      kjBadgeView;

@property(nonatomic, strong) EFExitObj *exitObj;

//-(void)autoLoginAction;
-(void)autoLoginAction:(BOOL)isCheck;
- (void)connectManager;

@end

