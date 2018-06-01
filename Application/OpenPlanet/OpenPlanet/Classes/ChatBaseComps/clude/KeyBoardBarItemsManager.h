//
//  OrganizeKeyBoardBarItems.h
//  ESPChatComps
//
//  Created by YRH on 2018/3/27.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

/*
 组织barItems
 */
#import <Foundation/Foundation.h>
#import "IIMStruct.h"
#import "ChatKeyBoard.h"
#import "FacePanel.h"
#import "MorePanelManager.h"
#import "TakingPicturesManager.h"
#import "RecordVideoManager.h"
#import "CWVoiceView.h"
#import "Constant.h"
#import "EFImageOperationView.h"

@protocol KeyBoardBarItemsManagerDelegate <NSObject, FacePanelDelegate>


@end

@interface KeyBoardBarItemsManager : NSObject

@property (nonatomic, weak) id <KeyBoardBarItemsManagerDelegate> delegate;

/**
 加载barItems
 
 @param postType postType description
 @param chatKeyBoard chatKeyBoard description
 @return return value description
 */
+ (NSArray *)chatKeyBoardToolbarItemsWithPostType:(postType)postType chatKeyBoard:(ChatKeyBoard<KeyBoardBarItemsManagerDelegate> *)chatKeyBoard;

@end

