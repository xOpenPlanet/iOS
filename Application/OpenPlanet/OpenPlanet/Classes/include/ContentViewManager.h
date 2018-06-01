//
//  ESPContentView.h
//  ESPMobile
//
//  Created by fly on 14/12/26.
//  Copyright (c) 2014年 Javor. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StubObject;

@interface ContentViewManager : UIView

+(UIView *)viewWithStubObject:(StubObject *)stubObject;

+(UIViewController *)viewControllerWithStubObject:(StubObject *)stubObject;


@end
