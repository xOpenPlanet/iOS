//
//  TCSafeArchitectureController.m
//  OpenPlanet
//
//  Created by 王胜利 on 2018/5/2.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCSafeArchitectureController.h"
#import "TalkChainHeader.h"
#import "TCMeNormalCell.h"
#import "TCSurePasswordController.h"
#import "TCBackUpPriviteKeyController.h"


static NSString *normalCellId = @"normalCellId";

@interface TCSafeArchitectureController ()<UITableViewDelegate,UITableViewDataSource>
/// 列表页
@property (strong, nonatomic) UITableView *tableView;
/// 数据源
@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation TCSafeArchitectureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
    self.title = @"安全加固";
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    [self createLocalData];
}

#pragma mark - 创建本地数据数据
- (void)createLocalData{
    
    NSArray *array1 = @[@{
                            @"type":normalCellId,
                            @"titleImage":@"me/me_backupPrivitekey.png",
                            @"title":@"备份基地门禁私钥",
                            @"rightImage":@"me/me_more.png",
                            @"vc":@"AboutMeViewController",
                            }
                        ];
    
    self.dataSource = @[array1];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegateAndDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray  *array = self.dataSource[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataSource[indexPath.section][indexPath.row];
    if ([dict[@"type"] isEqualToString:normalCellId]) {
        TCMeNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellId forIndexPath:indexPath];
        UIImage *titleImage = [UIImage theme_bundleImageNamed:dict[@"titleImage"]]();
        UIImage *rightImage = [UIImage theme_bundleImageNamed:dict[@"rightImage"]]();
        [cell cellWithTitleImage:titleImage title:dict[@"title"] rightImage:rightImage rightButtonAction:nil];
        return cell;
    }else{
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [TCSurePasswordController showWithSuperVc:self isRight:^(BOOL isSuccess, NSString *password) {
            if (isSuccess) {
                [self showTCHUDWithTitle:@""];
                [(CloudKeychainSigner *)self.signer unlockPassword:password callback:^(Signer *signer, NSError *error) {
                    [self hiddenTCHUD];
                    if (!error) {
                        NSString *privateKeyString =  [(CloudKeychainSigner *)signer account].privateKeyString;
                        [TCBackUpPriviteKeyController showWithSuperVc:self priviteKey:privateKeyString];
                    }else{
                        [self showSystemAlertWithTitle:@"提示" message:@"钱包解锁失败"];
                    }
                }];
            }
            
        }];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyload
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 80;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.sectionFooterHeight = 0.1;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView registerClass:[TCMeNormalCell class] forCellReuseIdentifier:normalCellId];
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view);
            }
        }];
    }
    return _tableView;
}

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}
@end
