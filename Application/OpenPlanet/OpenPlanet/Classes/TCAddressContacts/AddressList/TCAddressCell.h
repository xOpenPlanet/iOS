//
//  TCAddressCell.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/14.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCAddressCell : UITableViewCell

/**
 赋值联系人cell

 @param avatar 头像
 @param userName 名称
 */
- (void)cellWithAvatar:(UIImage *)avatar userName:(NSString *)userName tipImage:(UIImage *)tipImage;

@end
