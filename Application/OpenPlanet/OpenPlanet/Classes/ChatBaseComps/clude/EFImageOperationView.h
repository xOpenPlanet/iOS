//
//  EFImageOperationView.h
//  ESPChatComps
//
//  Created by 虎 谢 on 2018/3/29.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScanView.h"
#import "PictureSendManager.h"

@interface EFImageOperationView : UIView<ImageScanViewDelegate>

@property(nonatomic,strong) PictureSendManager *pictureSendManager;

-(void)imageScanViewReloadData;

@end
