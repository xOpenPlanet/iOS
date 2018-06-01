//
//  TCDiamondCell.h
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/23.
//  Copyright © 2018年 wsl. All rights reserved.
//  钻石cell

#import <UIKit/UIKit.h>
#import "TalkChainHeader.h"

typedef NS_ENUM(NSUInteger, DiamondCellType) {
    DiamondCellTypeNone = 0,
    DiamondCellTypeRefresh,
};

@interface TCDiamondCell : UITableViewCell

- (void)cellWithTitleImagePath:(NSString *)titleImagePath title:(NSString *)title rightTitle:(NSString *)rightTitle cellType:(DiamondCellType)cellType;

@end
