//
//  TCWalletCell.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/31.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkChainHeader.h"
#import "TCWalletModel.h"

@interface TCWalletCell : UITableViewCell

- (void)cellWithWalletModel:(TCWalletModel *)model
                      outMi:(VoidBlock)outMiBlock
                       inMi:(VoidBlock)inMiBlock
                transDetail:(VoidBlock)transDetailBlock;



@end
