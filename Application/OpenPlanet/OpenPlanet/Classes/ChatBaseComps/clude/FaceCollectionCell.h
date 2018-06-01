//
//  FaceCollectionCell.h
//  ESPChatComps
//
//  Created by YRH on 2018/4/8.
//  Copyright © 2018年 Pansoft. All rights reserved.
//

/*
 表情cell
 */

#import <UIKit/UIKit.h>
#import "FaceThemeModel.h"

@interface FaceCollectionCell : UICollectionViewCell

@property (nonatomic, readonly, copy) NSString *faceTitle;
@property (nonatomic, strong) FaceModel *faceModel;

@end
