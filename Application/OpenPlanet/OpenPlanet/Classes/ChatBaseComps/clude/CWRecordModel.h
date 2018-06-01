//
//  CWRecordModel.h
//  QQVoiceDemo
//
//  Created by 亦晴 on 2017/10/7.
//  Copyright © 2017年 亦晴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSington.h"

@interface CWRecordModel : NSObject

@property (nonatomic,copy) NSString *path;

@property (nonatomic,strong) NSArray *levels; // 振幅数组

@property (nonatomic,assign) NSInteger duration;

// 单例
singtonInterface;


@end
