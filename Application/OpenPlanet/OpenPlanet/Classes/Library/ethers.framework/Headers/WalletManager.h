//
//  WalletManager.h
//  TalkChain
//
//  Created by Javor Feng on 2018/3/14.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wallet.h"

@interface WalletManager : NSObject

+(void)setSharedWallet:(Wallet *)aWallet;

+(Wallet *)sharedWallet;

+(void)refreshWallet;

+(NSString *)milletToBalance:(NSString *)millet;

+(NSString *)BalanceToMillet:(NSString *)balance;

@end
