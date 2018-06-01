//
//  TCMeNormalCell.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/15.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkChainHeader.h"

@interface TCMeNormalCell : UITableViewCell

- (void)cellWithTitleImage:(UIImage *)titleImage title:(NSString *)title rightImage:(UIImage *)rightImage rightButtonAction:(VoidBlock)buttonBlock;

@end
