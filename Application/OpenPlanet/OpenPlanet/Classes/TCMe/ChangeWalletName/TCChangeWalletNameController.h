//
//  TCChangeNameController.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/27.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkChainHeader.h"

@interface TCChangeWalletNameController : UIViewController

+ (instancetype)showWithSuperVc:(UIViewController *)superVc oldName:(NSString *)oldName name:(StringBlock)nameBlock;

@end
