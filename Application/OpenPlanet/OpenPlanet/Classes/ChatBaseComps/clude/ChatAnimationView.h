//
//  ChatAnimationView.h
//  ESPChatComps
//
//  Created by 虎 谢 on 2018/4/2.
//  Copyright © 2018年 Pansoft. All rights reserved.
//  键盘点赞动图view

#import <UIKit/UIKit.h>

@protocol ChatAnimationViewDelegate

@optional

/**
 key:imageNAme   item名字     key：imageArray  动图数组

 @param imageDictionary <#imageDictionary description#>
 */
-(void)chatAnimationViewSelectWithImageDictionary:(NSDictionary *)imageDictionary;

@end

@interface ChatAnimationView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,weak)   id<ChatAnimationViewDelegate> delegate;
@property(nonatomic,strong) NSMutableArray               *dataSource;
@property(nonatomic,strong) UICollectionViewFlowLayout   *flowLayout;
@property(nonatomic,strong) UICollectionView             *collectionView;
@end
