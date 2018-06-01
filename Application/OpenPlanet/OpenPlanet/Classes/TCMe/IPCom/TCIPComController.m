//
//  TCIPComController.m
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/25.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCIPComController.h"
#import "TalkChainHeader.h"

static NSString *ipComCellId = @"ipComCellId";


@interface TCIPComController ()<UITableViewDelegate,UITableViewDataSource>

/// 列表页
@property (strong, nonatomic) UITableView *tableView;
/// 数据源
@property (strong, nonatomic) NSArray *dataSource;
@end

@implementation TCIPComController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
    self.title = @"IPCom星际通讯矿池";


    if (self.dataSource.count == 0) {
        EShopPromptTipView *promptView =  [self noDataPromptView];
        self.tableView.tableHeaderView = [UIView new];
        promptView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 44);
        self.tableView.tableHeaderView = promptView;
        [self.tableView reloadData];
    }

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegateAndDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ipComCellId forIndexPath:indexPath];
    return cell;
}

#pragma mark - lazyload
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.theme_backgroundColor  = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.theme_separatorColor = [UIColor theme_colorPickerForKey:@"separatorColor"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];

        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ipComCellId];
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
