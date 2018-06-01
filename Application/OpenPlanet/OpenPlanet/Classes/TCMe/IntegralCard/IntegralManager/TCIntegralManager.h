//
//  TCIntegralManager.h
//  TalkChain
//
//  Created by 王胜利 on 2018/4/14.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCIntegralManager : NSObject

/// 添加积分
+ (void)addIntegral:(NSUInteger)integral reason:(NSString *)reason;
/// 获取积分和
+ (NSString *)getIntegralSum;
/// 获取积分账单
+ (NSArray <NSDictionary *>*)getIntegralBill;

@end
