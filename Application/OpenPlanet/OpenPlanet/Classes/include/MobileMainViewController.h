//
//  MainViewController.h
//  ESPMobile
//
//  Created by Javor on 15/7/18.
//  Copyright (c) 2015年 Javor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StubObject.h"
#import "MobileWeatherView.h"
#import "BlockStyleHorizontalMenu.h"
#import "HorizontalScrollMenu.h"
#import "EFAvatar.h"

@class MobileMainViewController;

@protocol MobileMainViewControllerDelegate <NSObject>
@optional

-(void)onMainViewController:(MobileMainViewController *)mainViewController didSelectMenu:(StubObject *)stubObject;

@end

@interface MobileMainViewController : UIViewController<UIScrollViewDelegate, MobileWeatherViewDelegate,HorizontalScrollMenuDelegate,BlockStyleHorizontalMenuDelegate,EFAvatarDelegate>

@property (nonatomic, strong) StubObject *menuStubObject;
@property (nonatomic, copy  ) NSString   *menuStyle;
@property (nonatomic, strong) BlockStyleHorizontalMenu *blockMenuView;

@end

