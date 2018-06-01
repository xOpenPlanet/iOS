//
//  TCSafeArchitectureController.h
//  OpenPlanet
//
//  Created by 王胜利 on 2018/5/2.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ethers/CloudKeychainSigner.h>

@interface TCSafeArchitectureController : UIViewController

@property (strong, nonatomic) CloudKeychainSigner *signer;

@end
