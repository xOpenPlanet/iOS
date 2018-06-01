//
//  TCTransderSuccessController.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/23.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//  转账成功

#import "TCOutMiResultController.h"
#import "TalkChainHeader.h"
#import "WalletRequestManager.h"
#import "TCOutMiResultView.h"
#import "TCTools.h"
#import "JFTransferSendMessage.h"

@interface TCOutMiResultController ()

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIImageView *transferStateImageView;
@property (strong, nonatomic) UILabel *transferStateLabel;
@property (strong, nonatomic) UILabel *moneyLabel;

@property (strong, nonatomic) TCOutMiResultView *orderView;
@property (strong, nonatomic) TCOutMiResultView *timeView;
@property (strong, nonatomic) TCOutMiResultView *outAddressView;
@property (strong, nonatomic) TCOutMiResultView *inAddressView;

@property (strong, nonatomic) NSString *transferId;

@end

@implementation TCOutMiResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易详情";
    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];
    self.scrollView.theme_backgroundColor  = [UIColor theme_colorPickerForKey:@"viewBackgroud"];;
    self.topView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"cellBackgroud"];
    [self transferAction];
}

- (void)TransFinish{
    [ViewControllerManager popViewControllerAnimated:NO];
    [ViewControllerManager popViewControllerAnimated:YES];
}

#pragma mark - 转账Action
- (void)transferAction{
    [self.transferStateImageView setAnimationImages:[TCTools getHudAnimationImages]];
    [self.transferStateImageView setAnimationDuration:2.0];
    [self.transferStateImageView setAnimationRepeatCount:0];
    [self.transferStateImageView startAnimating];
    self.transferStateLabel.text = @"交易中";
    [self moneyLabel];
    
    WEAK(self)
    NSString *milletMoney = [WalletManager BalanceToMillet:self.moneyValue];
    [WalletRequestManager transferWithSigner:self.signer passsword:self.password toPhone:self.toPhone toAddress:self.toAddress moneyValue:milletMoney success:^(id result) {
        
        [weakself.transferStateImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@80);
        }];
        [weakself.view layoutIfNeeded];
        
        [weakself.transferStateImageView stopAnimating];
        weakself.transferStateImageView.animationImages  = @[];
        weakself.transferStateImageView.image = [UIImage theme_bundleImageNamed:@"me/transfer_success.png"]();
        
        NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] init];
        NSAttributedString *moneyAttributeStirng = [[NSAttributedString alloc] initWithString:[@"-" stringByAppendingString:weakself.moneyValue] attributes:@{NSFontAttributeName:BOLD_FONT(25),NSForegroundColorAttributeName:TCTipColor}];
        NSAttributedString *unitAttributeStirng = [[NSAttributedString alloc] initWithString:@"能量" attributes:@{NSFontAttributeName:BOLD_FONT(15),NSForegroundColorAttributeName:cLightGrayColor}];
        [mutableAttributeString appendAttributedString:moneyAttributeStirng];
        [mutableAttributeString appendAttributedString:unitAttributeStirng];
        weakself.moneyLabel.attributedText = mutableAttributeString;
        
        weakself.transferStateLabel.text = @"交易成功";
        
        [weakself.orderView viewWithTitle:@"交易ID" content:[result valueForKey:@"transactionHash"] isShowMiddleLine:YES];
        weakself.transferId = [result valueForKey:@"transactionHash"];
        
        NSString *oriTime = [result valueForKey:@"time"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *date = [dateFormatter dateFromString:oriTime];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *resultTimeString = [dateFormatter stringFromDate:date];
        
        [weakself.timeView viewWithTitle:@"交易时间" content:resultTimeString isShowMiddleLine:NO];
        
        [weakself.outAddressView viewWithTitle:@"转出基地ID" content:weakself.fromWalletAddress isShowMiddleLine:NO];
        [weakself.inAddressView viewWithTitle:@"转入基地ID" content:weakself.toAddress isShowMiddleLine:NO];
        
        if (self.type == TransferTypeFromChat) {
            [self sendChatTransferMessage];
        }
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(TransFinish)];
        
    } fail:^(NSString *errorDescription) {
        
        [weakself.transferStateImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@80);
        }];
        [weakself.view layoutIfNeeded];
        [weakself.transferStateImageView stopAnimating];
        weakself.transferStateImageView.animationImages  = @[];
        weakself.transferStateImageView.image = [UIImage theme_bundleImageNamed:@"me/transfer_fail.png"]();
        weakself.transferStateLabel.text = @"交换失败";
        weakself.orderView.hidden = YES;
        weakself.inAddressView.hidden = YES;
        weakself.outAddressView.hidden = YES;
        weakself.timeView.hidden = YES;
    }];
}

#pragma mark - 发送转账消息
- (void)sendChatTransferMessage{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:ss:mm"];
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    NSString *messageString = [NSString stringWithFormat:@"{\"receiveUserId\":\"%@\",\"receiveWalletAddress\":\"%@\",\"receiveIMUserId\":\"%@\",\"sendUserId\":\"%@\",\"sendWalletAddress\":\"%@\",\"sendIMUserId\":\"%@\",\"money\":\"%@\",\"tradingTime\":\"%@\",\"tradingID\":\"%@\"}",self.toPhone,self.toAddress,[EnvironmentVariable getPropertyForKey:@"toUserID" WithDefaultValue:@""],[EnvironmentVariable getWalletUserID],self.fromWalletAddress,[EnvironmentVariable getIMUserID],self.moneyValue,time,self.transferId];
    [JFTransferSendMessage sendTransferMessageWithToUserId:[EnvironmentVariable getPropertyForKey:@"toUserID" WithDefaultValue:@""] transferMessageString:messageString];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyload
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view);
            }
        }];
    }
    return _scrollView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = cWhiteColor;
        [self.scrollView addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.centerX.equalTo(self.scrollView);
        }];
        
    }
    return _topView;
}
- (UIImageView *)transferStateImageView{
    if (!_transferStateImageView) {
        _transferStateImageView = [UIImageView new];
        [self.topView addSubview:_transferStateImageView];
        [_transferStateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.topView);
            make.top.equalTo(self.topView).offset(30);
            make.width.height.equalTo(@50);
        }];
    }
    return _transferStateImageView;
}

- (UILabel *)transferStateLabel{
    if (!_transferStateLabel) {
        _transferStateLabel = [UILabel new];
        _transferStateLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"cellTitle"];
        _transferStateLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:_transferStateLabel];
        [_transferStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.topView);
            make.top.equalTo(self.transferStateImageView.mas_bottom).offset(10);
        }];
    }
    return _transferStateLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.font = BOLD_FONT(20);
        _moneyLabel.textColor = TCTipColor;
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.topView).inset(20);
            make.top.equalTo(self.transferStateLabel.mas_bottom).offset(20);
        }];
    }
    return _moneyLabel;
}


- (TCOutMiResultView *)orderView{
    if (!_orderView) {
        _orderView = [TCOutMiResultView new];
        [self.scrollView addSubview:_orderView];
        [_orderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom).offset(10);
            make.left.right.centerX.equalTo(self.scrollView);
        }];
    }
    return _orderView;
}


- (TCOutMiResultView *)timeView{
    if (!_timeView) {
        _timeView = [TCOutMiResultView new];
        [self.scrollView addSubview:_timeView];
        [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.orderView.mas_bottom).offset(10);
        }];
    }
    return _timeView;
}

- (TCOutMiResultView *)outAddressView{
    if (!_outAddressView) {
        _outAddressView = [TCOutMiResultView new];
        [self.scrollView addSubview:_outAddressView];
        [_outAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerX.equalTo(self.scrollView);
            make.top.equalTo(self.timeView.mas_bottom).offset(10);
        }];
    }
    return _outAddressView;
}

- (TCOutMiResultView *)inAddressView{
    if (!_inAddressView) {
        _inAddressView = [TCOutMiResultView new];
        [self.scrollView addSubview:_inAddressView];
        [_inAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerX.equalTo(self.scrollView);
            make.bottom.equalTo(self.scrollView).inset(10);
            make.top.equalTo(self.outAddressView.mas_bottom);
        }];
    }
    return _inAddressView;
}

@end
