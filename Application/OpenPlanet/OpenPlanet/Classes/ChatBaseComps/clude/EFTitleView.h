//
//  TitleView.h
//  Test
//
//  Created by 虎 谢 on 16/9/9.
//  Copyright © 2016年 谢虎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFTitleView.h"
#import "HorizontalScrollMenu.h"
#import "TagView.h"

@protocol JFTitleViewDelegate <NSObject>

- (void)jfTitleViewdidClickLeftButton:(id)sender;
- (void)jfTitleViewdidClickRightButton:(id)sender;
- (void)jfTitleViewdidClickTitleButton:(UIButton *)sender;

@end

@interface EFTitleView : UIView

@property(nonatomic,strong)  HorizontalScrollMenu    *menuView;

@property(nonatomic,strong) UIButton        *leftButton;

@property(nonatomic,strong) UIImageView     *leftView;

@property(nonatomic,strong) TagView         *tagView;

@property(nonatomic,strong)  StubObject *dataStub;

@property(nonatomic, weak) id<JFTitleViewDelegate> delegate;

@property(nonatomic,strong)NSMutableArray *menuArray;

@property(nonatomic,strong)NSMutableDictionary *titleDic;

-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array;

- (void)onTitleButtonClick:(UIButton *)sender;

-(void)dataStub:(StubObject *)stub ForController:(UIViewController *)viewController;

@end
