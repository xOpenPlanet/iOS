//
//  TCPriviteKeyController.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/27.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCBackUpPriviteKeyController : UIViewController

/// 显示备份私钥弹窗
+ (instancetype)showWithSuperVc:(UIViewController *)superVc priviteKey:(NSString *)priviteKey;

@end
