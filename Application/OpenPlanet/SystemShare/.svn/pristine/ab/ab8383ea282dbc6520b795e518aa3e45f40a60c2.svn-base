//
//  SystemShareController.m
//  Share
//
//  Created by 高建飞 on 2018/5/29.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "SystemShareController.h"
#import "Masonry.h"
#import "SystemShareWebUrlView.h"
#import "SystemShareImageDisplayView.h"
#import "SystemShareCell.h"
#import "MBProgressHUD.h"

static NSString *cellId = @"zoneCellId";

@interface SystemShareController ()<UITableViewDelegate, UITableViewDataSource, SystemShareWebUrlViewDelegate>

@property (nonatomic, strong) MBProgressHUD *hud; // 菊花
@property (nonatomic, strong) UIButton *cancelButton; // 取消按钮
@property (nonatomic, strong) UIView *bgView; // 最底View
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView; // 网址与图片显示的底层View
@property (nonatomic, strong) SystemShareImageDisplayView *imageView; // 图片
@property (nonatomic, strong) UILabel *textLabel; // 纯文字
@property (nonatomic, strong) SystemShareWebUrlView *webUrlView; // 网址展示View
@property (nonatomic, strong) NSMutableDictionary *dataDictionary; // 存放文件类型、网址、图片路径等信息
@property (nonatomic, strong) NSMutableArray *imagePathArray; // 多张图片

@end

@implementation SystemShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self shareLink]; // 获取分享链接
    });
}

- (void) createView {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }
        make.left.right.equalTo(self.view);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).with.offset(8);
        make.left.offset(0);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(40);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelButton.mas_bottom);
        make.left.right.equalTo(self.bgView);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.bgView);
    }];
}

#pragma mark -- 获取分享链接

- (void)shareLink {
    _imagePathArray = [NSMutableArray new];
    __block BOOL hasGetUrl = NO;
    [self.extensionContext.inputItems enumerateObjectsUsingBlock:^(NSExtensionItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.attachments enumerateObjectsUsingBlock:^(NSItemProvider *  _Nonnull itemProvider, NSUInteger idx, BOOL * _Nonnull stop) {
            if([itemProvider hasItemConformingToTypeIdentifier:@"public.image"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.centerX.equalTo(self.headerView);
                        make.top.bottom.equalTo(self.headerView);
                    }];
                });
                [itemProvider loadItemForTypeIdentifier:@"public.image"
                                                options:nil
                                      completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                                          self.dataDictionary[@"type"] = @"image";
                                          NSString *path = [NSString stringWithFormat:@"%@", item];
                                          NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
                                          NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:AppGroupName];
                                          NSString *name = [@([[NSDate date] timeIntervalSince1970]) stringValue];
                                          NSURL *fileURL = [groupURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                              [data writeToURL:fileURL atomically:YES];
                                          });
                                          [_imagePathArray addObject:fileURL.absoluteString];
                                          self.dataDictionary[@"path"] = _imagePathArray;
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [self.imageView viewWithImageUrls:_imagePathArray];
                                          });
                                      }];
            }else if ([itemProvider hasItemConformingToTypeIdentifier:@"public.url"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.webUrlView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.left.bottom.right.equalTo(self.headerView);
                    }];
                });
                
                [itemProvider loadItemForTypeIdentifier:@"public.url" options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                    
                    if ([(NSObject *)item isKindOfClass:[NSURL class]])
                    {
                        self.dataDictionary[@"type"] = @"url";
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.webUrlView.hidden = NO;
                            [self showHudView:@"正在加载"];
                            [self.webUrlView loadWebWithUrl:((NSURL *)item).absoluteString];
                        });
                    }
                }];
                hasGetUrl = YES;
                *stop = YES;
            }else if ([itemProvider hasItemConformingToTypeIdentifier:@"public.plain-text"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.left.bottom.right.equalTo(self.headerView).inset(8);
                    }];
                });
                [itemProvider loadItemForTypeIdentifier:@"public.plain-text" options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                    self.dataDictionary[@"type"] = @"text";
                    self.dataDictionary[@"text"] = ((NSString *)item);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.textLabel.hidden = NO;
                        self.textLabel.text = ((NSString *)item);
                    });
                }];
                hasGetUrl = YES;
                *stop = YES;
            }
            *stop = hasGetUrl;
        }];
    }];
}

#pragma mark --- 网页信息加载完成回调

- (void) webViewDidFinishWithWebInfo:(NSDictionary *)dictionary {
    [self hiddeHudView];
    self.dataDictionary[@"url"] = dictionary;
}

- (void)cancelBtnClickHandler:(id)sender{
    //取消分享
    [self.extensionContext cancelRequestWithError:[NSError errorWithDomain:@"CustomShareError" code:NSUserCancelledError userInfo:nil]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SystemShareCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.backgroundColor = [UIColor clearColor];
    switch (indexPath.row){
        case 0: {
            [cell cellDataWithDataDictionary:@{@"title":@"发送给好友", @"icon":@"icon_sendFriend@3x.png"}];
        } break;
        case 1: {
            [cell cellDataWithDataDictionary:@{@"title":@"分享到引力场", @"icon":@"icon_share@3x.png"}];
        } break;
        default: break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.dataDictionary[@"index"] = @(indexPath.row);
    UIResponder *responder = self;
    while (responder){
        if ([responder respondsToSelector:@selector(openURL:)])        {
            NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:AppGroupName];
            [myDefaults setObject:self.dataDictionary forKey:SystemShareKey];
            [myDefaults synchronize];
            [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:AppKey]];
            break;
        }
        responder = [responder nextResponder];
    }
    //执行分享内容处理
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

-(void)showHudView:(NSString *)text
{
    if(!_hud){
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.tag = 9991;
    }
    self.hud.labelText = text;
    [self.hud show:YES];
}

- (void) hiddeHudView {
    if(self.hud){
        [self.hud hide:YES];
        [self.hud removeFromSuperview];
    }
}

#pragma mark -- lazyload
- (UIView *) bgView {
    if(!_bgView){
        _bgView = [[UIView alloc] init];
        [self.view addSubview:_bgView];
        _bgView.layer.cornerRadius = 7;
        _bgView.layer.masksToBounds = YES;
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _bgView;
}

- (UIView *) headerView {
    if(!_headerView){
        _headerView = [[UIView alloc] init];
        [self.bgView addSubview:_headerView];
    }
    return _headerView;
}

- (UITableView *) tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[SystemShareCell class] forCellReuseIdentifier:cellId];
        [self.bgView addSubview:_tableView];
    }
    return _tableView;
}

- (SystemShareImageDisplayView *)imageView{
    if (!_imageView) {
        _imageView = [SystemShareImageDisplayView new];
        [self.headerView addSubview:_imageView];
    }
    return _imageView;
}

- (UIButton *) cancelButton {
    if(!_cancelButton){
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setTitle:@"返回" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelBtnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (SystemShareWebUrlView *) webUrlView {
    if(!_webUrlView){
        _webUrlView = [[SystemShareWebUrlView alloc] init];
        _webUrlView.hidden = YES;
        _webUrlView.delegate = self;
        [self.headerView addSubview:_webUrlView];
    }
    return _webUrlView;
}

- (UILabel *) textLabel {
    if(!_textLabel){
        _textLabel = [UILabel new];
        _textLabel.hidden = YES;
        _textLabel.numberOfLines = 0;
        [self.headerView addSubview:_textLabel];
    }
    return _textLabel;
}

- (NSMutableDictionary *) dataDictionary {
    if(!_dataDictionary){
        _dataDictionary = [NSMutableDictionary new];
    }
    return _dataDictionary;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
