//
//  UIView+keyboard.h
//  UIKeyBordPopUPCpntroller
//
//  Created by syl on 16/7/24.
//  Copyright © 2016年 syl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (keyboard)

-(void)registerViewForKeyboardNotifications;

-(void)resignViewForKeyboardNotifications;

-(void)keyboardWithShow:(CGFloat)time key_height:(CGRect)keyRect;

-(void)keyboardWithHide:(CGFloat)time;

@end
