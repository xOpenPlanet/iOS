//
//  TCMeController.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/15.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCMeController.h"
#import "TalkChainHeader.h"
#import "TCMeHeaderView.h"
#import "TCWalletCell.h"
#import "TCDiamondCell.h"
#import "TCMeNormalCell.h"
#import "TCTransferRecordsController.h"
#import "TCOutMiController.h"
#import "MineInformationViewController.h"
#import "TCInviteCodeController.h"
#import "MessageDbManager.h"
#import "WalletRequestManager.h"
#import "TCMeModel.h"
#import "TCSafeArchitectureController.h"
#import "EnergyExchangeViewController.h"
#import "EnvironmentUtil.h"

static NSString *walletCellId = @"walletCellId";
static NSString *diamondCellId = @"diamondCellId";
static NSString *normalCellId = @"normalCellId";

@interface TCMeController () <UITableViewDelegate,UITableViewDataSource>
/// 列表页
@property (strong, nonatomic) UITableView *tableView;
/// 列表页头部视图
@property (strong, nonatomic) TCMeHeaderView *headerView;
/// 数据源
@property (strong, nonatomic) NSArray *dataSource;
/// 钱包模型
@property (strong, nonatomic) TCWalletModel *model;
/// tableHeader头部item按钮数据
@property (strong, nonatomic) NSArray <TCMeItemModel *>*headerItems;

@end

@implementation TCMeController{
    NSString            *nickName;
    NSString            *name;
    NSString            *headURL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 修改用户名通知
    [NOTIFICATIONCENTER addObserver:self selector:@selector(changeNicknameAction:) name:changeMyName object:nil];
    
    // 1.获取用户信息
    [self loadLocalUserInfoData];
    // 2.创建本地数据
    [self createLocalData];
    // 3.刷新数据
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - 初始化用户信息
- (void)loadLocalUserInfoData{
    ///1. 获取钱包数据
    Wallet *wallet = [WalletManager sharedWallet];
    CloudKeychainSigner *signer = (CloudKeychainSigner *)[wallet.accounts objectAtIndex:wallet.activeAccountIndex];;
    Address *address = signer.address;
    NSString *addressString = [address checksumAddress];
    self.model.signer = signer;
    self.model.account = addressString;
    
    ///2. 获取用户数据
    NSString *userId = [EnvironmentVariable getIMUserID];
    MessageDbManager *DBManager = [[MessageDbManager alloc] init];
    NSDictionary * userInforDic = [DBManager selectUserInfor:[userId integerValue]];
    headURL = [userInforDic objectForKey:@"avatar"];
    nickName = [userInforDic objectForKey:@"nickName"];
    name = [userInforDic objectForKey:@"name"];
    
    
    MessageDbManager *dbMn = [[MessageDbManager alloc]init];
    NSString *imUserId = [EnvironmentVariable getIMUserID];
    NSArray *peopleArray = [dbMn selectFriendInfor:[imUserId integerValue] withType:0];
    NSArray *groupArray = [dbMn selectGroupInfor:[imUserId integerValue]];
    NSArray *applicationArray = [dbMn selectFriendInfor:[imUserId integerValue] withType:1];
    
    NSString *peopleCountString = peopleArray == nil ? @"0" : [NSString stringWithFormat:@"%ld",peopleArray.count];
    NSString *groupCountString = groupArray == nil ? @"0" : [NSString stringWithFormat:@"%ld",groupArray.count];
    NSString *applicationCountString = applicationArray == nil ? @"0" : [NSString stringWithFormat:@"%ld",applicationArray.count];
    
    NSArray *items = @[
                       @{@"title":@"好友",@"count":peopleCountString,},
                       @{@"title":@"部落",@"count":groupCountString,},
                       @{@"title":@"邀请",@"count":@"0",},
                       @{@"title":@"应用",@"count":applicationCountString,}
                       ];
    
    NSArray *itemModels = [TCMeItemModel mj_objectArrayWithKeyValuesArray:items];
    self.headerItems = itemModels;
    [self.headerView headerWithAvatar:headURL
                                 name:nickName
                               userId:[EnvironmentVariable getIMUserID]
                              account:addressString
                               planet:[EnvironmentVariable getPropertyForKey:@"planet" WithDefaultValue:@""]
                                items:itemModels];
    CGFloat height = [_headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, height);
    self.tableView.tableHeaderView = self.headerView;
}


#pragma mark - 修改用户名
-(void)changeNicknameAction:(NSNotification *)notification {
    NSString *nameStr = [notification.userInfo objectForKey:@"newName"];
    self.headerView.nameLabel.text = nameStr;
}

#pragma mark - 加载钱包账户
- (void)refreshMeData{
    // 1.刷新TableHeaderView数据
    [self refreshHeaderItems];
    // 2.请求个人信息
    [self requestUserInfo];
    // 3.请求钱包数据
    [self requestWalletBalance];
    // 4.请求银钻数据
    [self requestSilverDiamond];
}


#pragma mark - 刷新头部item数目
- (void)refreshHeaderItems{
    MessageDbManager *dbMn = [[MessageDbManager alloc]init];
    NSString *imUserId = [EnvironmentVariable getIMUserID];
    NSArray *peopleArray = [dbMn selectFriendInfor:[imUserId integerValue] withType:0];
    NSArray *groupArray = [dbMn selectGroupInfor:[imUserId integerValue]];
    NSArray *applicationArray = [dbMn selectFriendInfor:[imUserId integerValue] withType:1];
    NSString *peopleCountString = peopleArray == nil ? @"0" : [NSString stringWithFormat:@"%ld",peopleArray.count];
    NSString *groupCountString = groupArray == nil ? @"0" : [NSString stringWithFormat:@"%ld",groupArray.count];
    NSString *applicationCountString = applicationArray == nil ? @"0" : [NSString stringWithFormat:@"%ld",applicationArray.count];
    
    self.headerItems[0].count = peopleCountString;
    self.headerItems[1].count = groupCountString;
    self.headerItems[3].count = applicationCountString;
    [self.headerView reloadItems:self.headerItems];
}

#pragma mark - 请求个人信息
- (void)requestUserInfo{
    WEAK(self)
    [TCLoginManager getUserInfoWithSuccess:^(id result) {
        if ([result valueForKey:@"userInfo"]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[result valueForKey:@"userInfo"]];
            [dict setValue:[EnvironmentVariable getPropertyForKey:@"walletPassowrdMD5" WithDefaultValue:nil] forKey:@"walletPassword"];
            [EnvironmentUtil saveUserInfoWithDict:dict];
            [weakself.headerView reloadPlanet:[EnvironmentVariable getPropertyForKey:@"planet" WithDefaultValue:@""]];
            weakself.headerItems[2].count = [EnvironmentVariable getPropertyForKey:@"inviteCodeUsedCount" WithDefaultValue:@"0"];
            [weakself.headerView reloadItems:self.headerItems];
        }
    } fail:^(NSString *errorDescription) {
        
    }];
}

#pragma mark - 请求钱包余额
- (void)requestWalletBalance{
    NSArray *addresses = @[self.model.account];
    WEAK(self)
    [WalletRequestManager queryBalancesWithAddresses:addresses success:^(id result) {
        [weakself.tableView.mj_header endRefreshing];
        if ([[result valueForKey:@"result"] isEqualToString:@"success"] ) {
            NSDictionary *balances = [result valueForKey:@"balances"];
            [balances enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([self.model.account isEqualToString:(NSString *)key]) {
                    NSString *num = [NSString stringWithFormat:@"%@",obj];
                    self.model.energyCoinBalance = [WalletManager milletToBalance:num];
                }
            }];
            [weakself.tableView reloadData];
        }else{
            [weakself showSystemAlertWithTitle:@"提示" message:@"获取能量失败,请重试"];
        }
    } fail:^(NSString *errorDescription) {
        [weakself.tableView.mj_header endRefreshing];
        [weakself showSystemAlertWithTitle:@"提示" message:@"获取能量失败,请重试"];
    }];
}

#pragma mark - 请求银钻数
- (void)requestSilverDiamond{
    WEAK(self)
    [WalletRequestManager getSilverDiamondNumWithSuccess:^(id result) {
        if ([[result valueForKey:@"result"] isEqualToString:@"success"] ) {
            if ([result valueForKey:@"integralTotal"]) {
                NSString *integralTotal = [NSString stringWithFormat:@"%@",[result valueForKey:@"integralTotal"]];
                if (integralTotal.length == 0) {
                    integralTotal = @"0";
                }
                NSDictionary *silverDiamond  = self.dataSource[1];
                [silverDiamond setValue:integralTotal forKey:@"balance"];
                [weakself.tableView reloadData];
            }
        }
    } fail:^(NSString *errorDescription) {
        
    }];
}



#pragma mark - 创建本地数据数据
- (void)createLocalData{
    NSArray *array1 = @[@{
                            @"cellType":walletCellId,
                            }.mutableCopy
                        ];
    
    NSArray *array2 = @[@{
                            @"cellType":diamondCellId,
                            @"titleImage":@"me/me_silverDiamond.gif",
                            @"title":@"银钻",
                            @"balance":@"0",
                            @"vc":@"",
                            @"rightTitleType":@(DiamondCellTypeRefresh)
                            }.mutableCopy
                        ];
    NSArray *array3 = @[@{
                            @"cellType":diamondCellId,
                            @"titleImage":@"me/me_blackDiamond.gif",
                            @"title":@"黑钻",
                            @"balance":@"加入IPCom星际通讯矿池",
                            @"vc":@"TCIPComController",
                            @"rightTitleType":@(DiamondCellTypeNone),
                            }.mutableCopy
                        ];
    
    NSArray *array4 = @[@{
                            @"cellType":normalCellId,
                            @"titleImage":@"me/me_safeArchitecture.png",
                            @"title":@"安全加固",
                            @"rightImage":@"me/me_more.png",
                            @"vc":@"TCSafeArchitectureController",
                            @"isNeedParams":@(YES),
                            }
                        ];
    
    NSArray *array5 = @[@{
                            @"cellType":normalCellId,
                            @"titleImage":@"me/me_inviteCode.png",
                            @"title":@"邀请码",
                            @"rightImage":@"me/me_more.png",
                            @"vc":@"TCInviteCodeController",
                            }
                        ];
    
    NSArray *array6 = @[@{
                            @"cellType":normalCellId,
                            @"titleImage":@"me/me_about.png",
                            @"title":@"关于",
                            @"rightImage":@"me/me_more.png",
                            @"vc":@"AboutMeViewController",
                            },
                        ];
    
    self.dataSource = @[array1,array2,array3,array4,array5,array6];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ([dict[@"cellType"] isEqualToString:walletCellId]) {
        TCWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:walletCellId forIndexPath:indexPath];
        WEAK(self)
        [cell cellWithWalletModel:self.model  outMi:^{
            TCOutMiController *outVc = [TCOutMiController new];
            outVc.type = TransferTypeFromDefault;
            [weakself.navigationController pushViewController:outVc animated:YES];
        } inMi:^{
            EnergyExchangeViewController *inVc = [EnergyExchangeViewController new];
            [weakself.navigationController pushViewController:inVc animated:YES];
        } transDetail:^{
            TCTransferRecordsController *nextVc = [TCTransferRecordsController new];
            [weakself.navigationController pushViewController:nextVc animated:YES];
        }];
        return cell;
    }else if ([dict[@"cellType"] isEqualToString:diamondCellId]) {
        TCDiamondCell *cell = [tableView dequeueReusableCellWithIdentifier:diamondCellId forIndexPath:indexPath];
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@/image/%@",ThemeBundlePath,[ThemeManager getCurrentThemeName],dict[@"titleImage"]];
        [cell cellWithTitleImagePath:imagePath
                               title:dict[@"title"]
                          rightTitle:dict[@"balance"]
                            cellType:[dict[@"rightTitleType"] integerValue]];
        return cell;
    }else if ([dict[@"cellType"] isEqualToString:normalCellId]) {
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
    NSDictionary *dict = self.dataSource[indexPath.section][indexPath.row];
    if ([dict[@"cellType"] isEqualToString:normalCellId] || [dict[@"type"] isEqualToString:diamondCellId]) {
        NSString *vcName = dict[@"vc"];
        if (vcName && vcName.length > 0) {
            if (dict[@"isNeedParams"] && [dict[@"isNeedParams"] boolValue]) {
                UIViewController *vc = [NSClassFromString(vcName) new];
                if ([vcName isEqualToString:@"TCSafeArchitectureController"]) {
                    [(TCSafeArchitectureController *)vc setSigner:self.model.signer];
                }
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                UIViewController *vc = [NSClassFromString(vcName) new];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0?0.1:16;
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
        [_tableView registerClass:[TCWalletCell class] forCellReuseIdentifier:walletCellId];
        [_tableView registerClass:[TCDiamondCell class] forCellReuseIdentifier:diamondCellId];
        [_tableView registerClass:[TCMeNormalCell class] forCellReuseIdentifier:normalCellId];
        
        [self.view addSubview:_tableView];
        BOOL isIpx = [[EnvironmentVariable getPropertyForKey:@"isIpx" WithDefaultValue:@""] boolValue];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (isIpx) {
                make.bottom.equalTo(self.view).with.offset(-EF_X_FOOTERHEIGHT);
            }else{
                make.bottom.equalTo(self.view).with.offset(0);
            }
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            } else {
                make.top.equalTo(self.view);
            }
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
        }];
        
        
        _tableView.mj_header = [TCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMeData)];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (TCMeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [TCMeHeaderView new];
        CGFloat height = [_headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, height);
        WEAK(self)
        /// 用户信息点击回调
        _headerView.userInfoBlock = ^{
            MineInformationViewController *vc = [MineInformationViewController new];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        /// item点击事件回调
        _headerView.itemBlock = ^(TCMeItemModel *model) {
            
        };
        // 拷贝账户点击事件回调
        _headerView.copyAccountBlock  = ^{
            [UIPasteboard generalPasteboard].string = SafeString(weakself.model.account);
            [weakself.view jk_makeToast:@"基地ID已复制" duration:0.8f position:JKToastPositionCenter];
        };
    }
    return _headerView;
}

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

- (TCWalletModel *)model{
    if (!_model) {
        _model = [TCWalletModel new];
        _model.energyCoinTitle = @"能量";
        _model.energyCoinBalance = @"0";
        _model.account = @"";
        _model.accountBalance = @"0";
        _model.inMiImage = [UIImage theme_bundleImageNamed:@"me/me_in.png"]();
        _model.inMiTitle = @" 转入";
        _model.outMiImage = [UIImage theme_bundleImageNamed:@"me/me_out.png"]();
        _model.outMiTitle = @" 转出";
        _model.transMiImage = [UIImage theme_bundleImageNamed:@"me/me_transaction.png"]();
        _model.transMiTitle = @"交易明细";
        _model.transMiRightImage = [UIImage theme_bundleImageNamed:@"me/me_more.png"]();
    }
    return _model;
}

- (NSArray <TCMeItemModel *>*)headerItems{
    if (!_headerItems) {
        _headerItems = [NSArray array];
    }
    return _headerItems;
}


@end
