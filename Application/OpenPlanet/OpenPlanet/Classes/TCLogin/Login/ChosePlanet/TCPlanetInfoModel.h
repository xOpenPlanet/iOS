//
//  TCPlanetInfoModel.h
//  RuntimeTest
//
//  Created by YRH on 2018/4/20.
//  Copyright © 2018年 YRH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TCPlanetInfoModel : NSObject

/// 星球名
@property (nonatomic, copy) NSString *name;
/// 英文名
@property (nonatomic, copy) NSString *enName;
/// 介绍
@property (nonatomic, copy) NSString *information;
/// 图片名称
@property (nonatomic, copy) NSString *imageName;
/// 图片
@property (nonatomic, strong) UIImage *planetImage;

@end
