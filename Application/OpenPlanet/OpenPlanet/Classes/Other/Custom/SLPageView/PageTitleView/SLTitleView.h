//
//  SLTitleView.h
//  EShop
//
//  Created by 王胜利 on 2018/2/24.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "SLBasePageTitleView.h"

typedef enum : NSUInteger {
    /// 默认标题类型(均分)
    SLPageViewTitleTypeNone,
    /// 自适应标题宽度标题
    SLPageViewTitleTypeTitleWidthAutomatic,
} SLPageViewTitleType;

@interface SLTitleView : SLBasePageTitleView


/**
 配置标题栏样式并显示标题栏
 
 @param titles 标题数组
 @param selectBtnIdx 按钮选择事件回调
 @param titleNormalColor 标题默认颜色
 @param titleSelectColor 标题选中颜色
 @param lineColor 选中标题线的颜色
 @param titleType 标题类型
 return 标题栏实例变量
 */
+ (instancetype)viewWithTitles:(NSArray *)titles
                   titleBtnSelect:(TitleBtnSelect)selectBtnIdx
                 TitleNormalColor:(UIColor *)titleNormalColor
                titleSelectColor:(UIColor *)titleSelectColor
                       lineColor:(UIColor *)lineColor
                       titleType:(SLPageViewTitleType)titleType;

@end

@interface SLPageEntity : NSObject

/// 标题
@property (strong, nonatomic) NSString *title;
/// 代码
@property (strong, nonatomic) NSString *node;
/// 其他参数
@property (strong, nonatomic) NSString *otherDict;
/// PageView该实体所对应的View
@property (strong, nonatomic) UIView *childView;

@end
