//
//  ContractEncoder.h
//  ethers
//
//  Created by Javor Feng on 2018/3/9.
//  Copyright © 2018年 Ethers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFArgument.h"

@interface ContractEncoder : NSObject

+(NSString *)encodeFunction:(NSString *)function args:(NSArray<JFArgument *> *)args;
+(NSString *)encodeFunction:(NSString *)function;
+(NSString *)encodeArgs:(NSArray<JFArgument *> *)args;
+(NSData *)stringToData:(NSString *)string;
+(NSString *)encodeInt:(NSInteger)intvalue;
+(NSString *)encodeBool:(BOOL)boolValue;
+(NSString *)encodeString:(NSString *)stringValue;
+(NSString *)hexByDecimal:(NSInteger)decimal;

@end
