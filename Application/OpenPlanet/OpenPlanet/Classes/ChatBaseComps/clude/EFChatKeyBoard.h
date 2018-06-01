//
//  ChatKeyBoardBusiness.h
//  ESPChatComps
//
//  Created by YRH on 2018/3/26.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

#import "ChatKeyBoard.h"
#import "IIMStruct.h"

@interface EFChatKeyBoard : ChatKeyBoard

/**
 根据消息的postType来决定显示哪些barItems

 @param postType postType
 */
- (void)chatKeyBoardToolbarItemsWithPostType:(postType)postType;

@end
