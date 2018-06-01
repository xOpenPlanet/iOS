//
//  TCBackUpMemoryWordController.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/9.
//  Copyright © 2018年 wsl. All rights reserved.
//  备份助记词控制器

#import "TCBackUpMemoryWordController.h"
#import "TCBackUpMemoryView.h"
#import "TCSureMemoryWordController.h"
#import <ethers/Account.h>


@interface TCBackUpMemoryWordController ()
@property (strong, nonatomic) TCBackUpMemoryView *rootView;
@end

@implementation TCBackUpMemoryWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"备份助记词";
    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud" fromDictName:@"wallet"];
    [self rootView];

    // 账户
    NSString *accountString = [self.account.address checksumAddress];
    self.rootView.accountLabel.text = accountString;

    //助记词
    NSString *memoryStr = self.account.mnemonicPhrase;
    NSArray *memorys = [memoryStr componentsSeparatedByString:@" "];
    [self.rootView setMemoryWords:memorys];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 返回
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 下一步
- (void)nextAction{
    TCSureMemoryWordController * vc = [TCSureMemoryWordController new];
    vc.password = self.password;
    vc.phone = self.phone;
    vc.type = self.type;
    vc.memoryWord = self.rootView.memoryWords;
    vc.account = self.account;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazyload
- (TCBackUpMemoryView *)rootView{
    if (!_rootView) {
        _rootView = [TCBackUpMemoryView new];
        NSString *nextTitle = @"下一步";
        [_rootView.nextButton setTitle:nextTitle forState:UIControlStateNormal];
        [_rootView.tipLabel setText:@"助记词用于恢复基地账户或重置基地密码，将它准确的抄写到纸上，并存放在只有您自己知道的安全地方。" lineSpacing:2];
        _rootView.subTitleLabel.text = @"抄写下您的基地账户助记词";
        _rootView.subTipView.tipLabel.text = @"抄写下上面的助记词，将获得银钻奖励";
        _rootView.subTipView.rewardLabel.text = @"10000";
        [_rootView.nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:_rootView];
        [_rootView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view);
            }
        }];
    }
    return _rootView;
}


@end
