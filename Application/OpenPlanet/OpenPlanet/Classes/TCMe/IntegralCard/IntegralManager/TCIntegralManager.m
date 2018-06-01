//
//  TCIntegralManager.m
//  TalkChain
//
//  Created by 王胜利 on 2018/4/14.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "TCIntegralManager.h"
#import "Constant.h"
#import "CategoryHeader.h"

#define kIntegralBillKey @"integralBillKey"

@implementation TCIntegralManager
/// 添加积分
+ (void)addIntegral:(NSUInteger)integral reason:(NSString *)reason{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString dateWithTimeInterval:timeInterval formater:@"yyyy-MM-dd hh:ss"];

    NSDictionary *tmpDict = @{
                              @"reason":reason,
                              @"integral":@(integral),
                              @"time":timeString
                              };

    NSArray *allIntegralBill = [self getIntegralBill];
    NSMutableArray *mutableIntegralBill = [NSMutableArray arrayWithArray:allIntegralBill];
    [mutableIntegralBill insertObject:tmpDict atIndex:0];

    /// 存储
    [USERDEFAULT setObject:mutableIntegralBill forKey:kIntegralBillKey];
}

/// 获取积分和
+ (NSString *)getIntegralSum{
    NSArray *allIntegralBill = [self getIntegralBill];

    NSUInteger integral = 0;
    for (NSMutableDictionary *tmpDict in allIntegralBill) {
        integral += [tmpDict[@"integral"] integerValue];
    }

    return [NSString stringWithFormat:@"%ld",integral];
}
/// 获取积分账单
+ (NSArray <NSDictionary *>*)getIntegralBill{
    NSArray *array = [USERDEFAULT arrayForKey:kIntegralBillKey];
    return SafeArray(array);
}


@end
