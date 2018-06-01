//
//  TCMeHeaderButton.h
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/24.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkChainHeader.h"

@interface TCMeHeaderButton : UIView
- (void)buttonWithNum:(NSString *)num title:(NSString *)title touch:(VoidBlock)touchBlock;
- (void)refreshButtonWithNum:(NSString *)num title:(NSString *)title;
@end
