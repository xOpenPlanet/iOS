//
//  TCAddressController.m
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/14.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "TCAddressController.h"
#import <AddressBook/AddressBook.h>
#import "TalkChainHeader.h"
#import "TCAddressCell.h"
#import "TCAddressDetailController.h"
#import "MobileMainViewController.h"
#import "RITLContactsManager.h"
#import "RITLContactObject.h"
#import "NSString+RITLContactFile.h"
#import "EdgeInsetLabel.h"
#import "UIViewController+TCHUD.h"

static NSString *const addressCellId = @"addressCellId";

@interface TCAddressController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) RITLContactsManager * contactManager;
//存放联系人的数组，存放直接请求出的联系人数组
@property (nonatomic, copy)NSArray <RITLContactObject *> *  contactObjects;
//存放处理过的数组
@property (nonatomic, copy)NSArray <NSDictionary *> * handleContactObjects;
/// 列表页
@property (strong, nonatomic) UITableView *tableView;
/// 搜索数据源
@property (strong, nonatomic) NSMutableArray *searchDataSource;
/// 搜索框
@property (strong, nonatomic) UISearchBar *searchBar;
/// 搜索框是否活跃
@property (assign, nonatomic) BOOL isSearchBarActivity;
@end

@implementation TCAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
    self.automaticallyAdjustsScrollViewInsets = NO;


    self.contactManager = [[RITLContactsManager alloc]init];
    self.tableView.tableHeaderView = self.searchBar;
    [self requestContacts];
}

//开始请求所有的联系人
- (void)requestContacts{
    [self showTCHUDWithTitle:@"正在请求通讯录数据"];
    WEAK(self)
    if (@available(iOS 9.0, *)) {
        self.contactManager.descriptors = [NSString RITLContactNamePhoneKeys];
    } else {

    }

    self.contactManager.contactDidChange = ^(NSArray<RITLContactObject *> * _Nonnull contacts) {
        [weakself __reloadTableView:contacts];
    };

    //开始请求
    [self.contactManager requestContactsComplete:^(NSArray<RITLContactObject *> * _Nonnull contacts) {
        [weakself __reloadTableView:contacts];
        [weakself loadNetAddressData];
    } defendBlock:^{
        UIAlertController *alertVc = [UIAlertController  alertControllerWithTitle:@"提示" message:@"通讯录未授权" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [APPLICATION openURL:[NSURL URLWithString:@"App-Prefs:root=Privacy"]];
        }]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself hiddenTCHUD];
            [weakself presentViewController:alertVc animated:YES completion:nil];
        });
    }];
}

- (void)__reloadTableView:(NSArray <RITLContactObject *> *)contactObjects{
    //开始赋值
    self.contactObjects = contactObjects;
    [self handleContactObjects];
    //刷新
    [self.tableView reloadData];
}


#pragma mark - 请求网络通讯录数据
- (void)loadNetAddressData{
    WEAK(self)
    [TCLoginManager loadPeopleWithSuccess:^(id result) {
        [weakself hiddenTCHUD];
        if ([result valueForKey:@"linkMans"]) {
            for (NSDictionary *userDict in [result valueForKey:@"linkMans"]) {
                if ([userDict valueForKey:@"linkManImUserId"] && ![[userDict valueForKey:@"linkManImUserId"] isEqual:@0]) {
                    NSNumber *imUserId = [userDict valueForKey:@"linkManImUserId"];
                    NSString *linkManIdMd5 = [userDict valueForKey:@"linkManIdMd5"];
                    if (![linkManIdMd5 isEqualToString:[StringUtil encodeWithMD5:[EnvironmentVariable getWalletUserID]]]) {
                        for (RITLContactObject *contact in self.contactObjects) {
                            if (StringIsEmpty(contact.imUserId)) {
                                for (RITLContactPhoneObject *phone in contact.phoneObject) {
                                    NSString *phoneMd5 = [StringUtil encodeWithMD5:phone.phoneNumber];
                                    if ([phoneMd5 isEqualToString:linkManIdMd5] ) {
                                        contact.imUserId = [imUserId stringValue];
                                    }
                                }
                            }
                        }
                    }
                }
            }
            /// 通讯录排序
            [weakself __reloadTableView:self.contactObjects];
        }
    } fail:^(NSString *errorDescription) {
        [weakself hiddenTCHUD];
        NSLog(@"获取通讯录失败:%@",errorDescription);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegateAndDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.isSearchBarActivity? 1 : self.handleContactObjects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearchBarActivity) {
        return self.searchDataSource.count;
    }
    NSArray *tmpArray = self.handleContactObjects[section][@"content"];
    return tmpArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellId forIndexPath:indexPath];
    NSArray *tmpArray = self.handleContactObjects[indexPath.section][@"content"];
    RITLContactObject * contactObject = self.isSearchBarActivity?self.searchDataSource[indexPath.row]:tmpArray[indexPath.row];
    UIImage *image = contactObject.headImage ? contactObject.headImage : [UIImage imageNamed:@"contact_default_avatar"];
    UIImage *tipImage = StringIsEmpty(contactObject.imUserId)?nil:[UIImage imageNamed:@"contact_firend_tip"];
    [cell cellWithAvatar:image userName:contactObject.nameObject.name tipImage:tipImage];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RITLContactObject *user = self.isSearchBarActivity? self.searchDataSource[indexPath.row]:self.handleContactObjects[indexPath.section][@"content"][indexPath.row ];
    TCAddressDetailController *addressDetailVc = [TCAddressDetailController new];
    addressDetailVc.contact =  user;
    [self.navigationController pushViewController:addressDetailVc animated:YES];
}

//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *titles = [NSMutableArray array];
    [self.handleContactObjects enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:obj[@"title"]];
    }];
    return self.isSearchBarActivity?@[]:titles;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *title = self.handleContactObjects[section][@"title"];
    EdgeInsetLabel *titleLabel = [EdgeInsetLabel new];
    titleLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    titleLabel.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
    titleLabel.text = [NSString stringWithFormat:@" %@",title];
    titleLabel.textColor = cTextColor;
    titleLabel.font = BOLD_FONT(16);
    titleLabel.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    return self.isSearchBarActivity?nil:titleLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.isSearchBarActivity?0: UITableViewAutomaticDimension;
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES]; // 动画效果显示取消按钮
    self.isSearchBarActivity = YES;
    [self.tableView reloadData];

}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    /// 搜索文字
    NSString *searchStr = searchText;

    NSMutableArray *searchResult = [NSMutableArray array];
    /// 遍历结果
    for (RITLContactObject *contact in self.contactObjects) {
        /// 谓词搜索
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchStr];
        if ([pre evaluateWithObject:contact.nameObject.name] ) {
            [searchResult addObject:contact];
        }else{
            for (RITLContactPhoneObject *phone in contact.phoneObject) {
                if ([pre evaluateWithObject:phone.phoneNumber]) {
                    [searchResult addObject:contact];
                }
            }
        }
    }
    self.searchDataSource = searchResult;
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.isSearchBarActivity = NO;
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.searchDataSource removeAllObjects];
    [self.tableView reloadData];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

-(NSArray<NSArray *> *)handleContactObjects{
    return [RITLContactSortManager defaultHandleContactObject:self.contactObjects];
}

#pragma mark - lazyload
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 80;
        _tableView.estimatedSectionHeaderHeight = 1;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.theme_separatorColor = [UIColor theme_colorPickerForKey:@"separatorColor"];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[TCAddressCell class] forCellReuseIdentifier:addressCellId];

        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索联系人";
        [_searchBar sizeToFit];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];
        _searchBar.showsCancelButton =NO;
        _searchBar.delegate = self;
    }
    return _searchBar;
}


- (NSArray<RITLContactObject *> *)contactObjects{
    if (!_contactObjects) {
        _contactObjects = [NSMutableArray array];
    }
    return _contactObjects;
}

- (NSMutableArray *)searchDataSource{
    if (!_searchDataSource) {
        _searchDataSource = [NSMutableArray array];
    }
    return _searchDataSource;
}

@end

