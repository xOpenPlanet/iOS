//
//  TCUploadFansController.h
//  OSPTalkChain
//
//  Created by 王胜利 on 2018/3/9.
//  Copyright © 2018年 wsl. All rights reserved.
//  上传粉丝控制器

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UploadFansType) {
    UploadFansTypeRegister,
    UploadFansTypeSync,
};

@interface TCUploadFansController : UIViewController

@property (assign, nonatomic) UploadFansType type;

@end
