//
//  SystemShareWebUrlView.h
//  Share
//
//  Created by 高建飞 on 2018/5/30.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SystemShareWebUrlViewDelegate<NSObject>

/// 网页加载完成，将网页信息回传
- (void) webViewDidFinishWithWebInfo:(NSDictionary *) dictionary;

@end

@interface SystemShareWebUrlView : UIView

@property (nonatomic, strong) id<SystemShareWebUrlViewDelegate> delegate;
/// 赋值
- (void) loadWebWithUrl:(NSString *)url;

@end
