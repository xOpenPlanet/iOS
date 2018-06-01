//
//  ChatAnimationCollectionCell.h
//  ESPChatComps
//
//  Created by 虎 谢 on 2018/4/2.
//  Copyright © 2018年 Pansoft. All rights reserved.
//  键盘点赞动图cell

#import <UIKit/UIKit.h>

@interface ChatAnimationCollectionCell : UICollectionViewCell
///item的图片
@property(nonatomic,strong) UIImageView         *animationImageView;
///动图数组
@property(nonatomic,strong) NSDictionary       *imageDic;
///item的label
@property(nonatomic,strong) UILabel             *animationImageLabel;
@end
