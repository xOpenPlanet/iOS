//
//  TCMeHeaderView.h
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/23.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkChainHeader.h"
#import "TCMeModel.h"

typedef void(^TCMeItemBlock)(TCMeItemModel *model);

@interface TCMeHeaderView : UIView

- (void)headerWithAvatar:(NSString *)avatar
                    name:(NSString *)name
                  userId:(NSString *)userId
                 account:(NSString *)account
                  planet:(NSString *)planet
                   items:(NSArray<TCMeItemModel *> *)items;


- (void)reloadPlanet:(NSString *)planet;
- (void)reloadItems:(NSArray<TCMeItemModel *> *)items;

/// 用户名
@property (strong, nonatomic) UILabel *nameLabel;

@property (copy, nonatomic) VoidBlock copyAccountBlock;
@property (copy, nonatomic) VoidBlock userInfoBlock;
@property (copy, nonatomic) TCMeItemBlock itemBlock;

@end

