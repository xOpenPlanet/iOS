//
//  TCAddressDetailController.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/15.
//  Copyright © 2018年 wsl. All rights reserved.
//  联系人详情页控制器

#import "TCAddressDetailController.h"
#import "TCAddressDetailCell.h"
#import "TCAddressDetailHeaderView.h"
#import "TalkChainHeader.h"
#import "EFPersonChatViewController.h"
#import "EFChatViewController.h"

static NSString *const phoneCellId = @"addressCellId";

@interface TCAddressDetailController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

/// 列表页
@property (strong, nonatomic) UITableView *tableView;
/// headerView
@property (strong, nonatomic) TCAddressDetailHeaderView *headerView;
/// 底部发起会话按钮
@property (strong, nonatomic) UIButton *bottomButton;


@end

@implementation TCAddressDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = cWhiteColor;

    // 添加手势返回效果
    self.navigationController.interactivePopGestureRecognizer.delegate=self;
    // 关闭自动Insets
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    // 赋值显示头部View
    [self showHeaderViewData];

    // 加载TableView
    [self tableView];

    if (!StringIsEmpty(self.contact.imUserId)) {
        [self.bottomButton setTitle:@"发消息" forState:UIControlStateNormal];
    }else{
        [self.bottomButton removeFromSuperview];
    }

}

#pragma mark - 动态隐藏导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - 赋值显示头部View
- (void)showHeaderViewData{
    WEAK(self)
    [self.headerView.backButton ex_touchUpInside:^{
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
    self.headerView.topBgImageView.image = [UIImage imageNamed:@"contact_detail_bg"];
    self.headerView.avatarImageView.image = self.contact.headImage?self.contact.headImage:[UIImage imageNamed:@"contact_detail_default_avatar"];
    self.headerView.titleLabel.text = self.contact.nameObject.name;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y <= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark - 去聊天
- (void)toChat{
    EFPersonChatViewController *chatVc = [[EFPersonChatViewController alloc] initWithUserID:[self.contact.imUserId integerValue]];
    MessageDbManager *messageDbManeger = [[JFMessageManager sharedMessageManager] messageDBManager];
    NSString *nickName = [messageDbManeger nameFromUsersWithId:[self.contact.imUserId integerValue]];
    chatVc.nickName = nickName;
    chatVc.chatType = PersonType;

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStylePlain) target:nil action:nil];

    // 聊天界面头像的形状
    NSString *shape = [EnvironmentVariable getPropertyForKey:@"shape" WithDefaultValue:@""];
    Byte cellHeaderImageViewShape;
    if ([shape isEqualToString:@"Circle"]) {
        cellHeaderImageViewShape = HeaderImageViewShapeCircle;
    } else if ([shape isEqualToString:@"Square"]) {
        cellHeaderImageViewShape = HeaderImageViewShapeSquare;
    } else {
        cellHeaderImageViewShape = HeaderImageViewShapeSquare;
    }
    chatVc.cellHeaderImageViewShape = cellHeaderImageViewShape;
    //传递参数
    [self.navigationController pushViewController:chatVc animated:YES];
}

#pragma mark - UITableViewDelegateAndDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contact.phoneObject.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCAddressDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneCellId forIndexPath:indexPath];
    RITLContactPhoneObject *phone = self.contact.phoneObject[indexPath.row];
    [cell cellWithPhone:[StringUtil encodeWithMD5:phone.phoneNumber] phoneTip:phone.phoneTitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyload
- (TCAddressDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TCAddressDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3.0 + 80)];
        [self.view addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.inset(0);
        }];
    }
    return _headerView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 80;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.sectionFooterHeight = UITableViewAutomaticDimension;

        [_tableView registerClass:[TCAddressDetailCell class] forCellReuseIdentifier:phoneCellId];

        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.bottomButton.mas_top).offset(-20).priority(100);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).priority(200);
            } else {
                make.bottom.equalTo(self.view).priority(200);
            }
        }];
    }
    return _tableView;
}



- (UIButton *)bottomButton{
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _bottomButton.backgroundColor = TCThemeColor;
        _bottomButton.tintColor = cWhiteColor;
        _bottomButton.layer.cornerRadius = 22.5;

        [self.view addSubview:_bottomButton];
        [_bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view).inset(20);
            make.height.equalTo(@45);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).inset(20);
            } else {
                make.bottom.equalTo(self.view.mas_bottom).inset(20);
            }
        }];

        [_bottomButton addTarget:self action:@selector(toChat) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

@end
