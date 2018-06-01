//
//  TCPrivateController.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/9.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCPrivateController.h"
#import "TalkChainHeader.h"

@interface TCPrivateController ()

@end

@implementation TCPrivateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
    self.title = @"服务与隐私条款";
    WEAK(self)
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ex_itemWithTitle:@"关闭" style:UIBarButtonItemStyleDone handler:^(id sender) {
        [weakself dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
