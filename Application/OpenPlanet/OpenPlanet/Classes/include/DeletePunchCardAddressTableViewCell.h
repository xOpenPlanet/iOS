//
//  DeletePunchCardAddressTableViewCell.h
//  ESPChatComps
//
//  Created by 苏友龙 on 2017/6/6.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeletePunchCardAddressTableViewCellDelegate <NSObject>

- (void)backDeleteAddress:(NSString *)specific;

@end

@interface DeletePunchCardAddressTableViewCell : UITableViewCell

- (void)setNameLabel:(NSString *)name withSpecificLabel:(NSString *)specific;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *specificLabel;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic,weak) id<DeletePunchCardAddressTableViewCellDelegate>delegate;

@end
