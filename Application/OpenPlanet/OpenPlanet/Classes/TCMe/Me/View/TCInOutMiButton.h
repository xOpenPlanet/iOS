//
//  TCInOutMiButton.h
//  TalkChain
//
//  Created by 王胜利 on 2018/3/22.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkChainHeader.h"

@interface TCInOutMiButton : UIView

- (void)buttonWithImage:(UIImage *)image title:(NSString *)title isShowLeftLine:(BOOL)isShowLeftLine tap:(VoidBlock)tapBlock;

@end
