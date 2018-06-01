//
//  MorePanelBLL.h
//  ESPChatComps
//
//  Created by YRH on 2018/3/27.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MorePanel.h"

@protocol MorePannelBLLDelegate <NSObject>

@optional
- (void)morePanelBLL:(MorePanel *)morePannel didSelectItemIndex:(NSInteger)index;

@end

@interface MorePanelManager : NSObject

@property (nonatomic, readonly) MorePanel *morePanel;

@property (nonatomic, weak) id<MorePannelBLLDelegate> delegate;

@end
