//
//  JFTransfDetailsCell.h
//  ESPChatComps
//
//  Created by YRH on 2018/4/27.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

/*
 转账详情cell
 */

#import <UIKit/UIKit.h>

@class JFTransferDetailsCellModel;
@interface JFTransferDetailsCell : UITableViewCell

@property (nonatomic, strong) JFTransferDetailsCellModel *cellModel;

@end

@interface JFTransferDetailsCellModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

@end
