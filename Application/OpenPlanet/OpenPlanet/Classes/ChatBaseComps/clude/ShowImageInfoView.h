//
//  ShowImageInfoView.h
//  ESPChatComps
//
//  Created by 于仁汇 on 16/12/24.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMStructMessage.h"

@protocol ShowImageInfoViewDelegate <NSObject>

- (void)whenTapShowImage:(UIView *)view;

@end

@interface ShowImageInfoView : UIView
{
    NSTimer     *_timer;
    
    NSString    *_QRDealStr;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *zoomScrollView;
@property (nonatomic, strong) UIImageView *showImage;
@property (nonatomic, weak) id<ShowImageInfoViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame allImageArray:(NSMutableArray *)allImageArray thisMessage:(IMStructMessage *)message currentImage:(UIImage *)image;

@end
