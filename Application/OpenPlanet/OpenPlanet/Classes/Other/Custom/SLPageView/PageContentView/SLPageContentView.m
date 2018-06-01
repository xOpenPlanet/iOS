//
//  SLPageContentView.m
//  TalkChain
//
//  Created by 王胜利 on 2018/4/8.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "SLPageContentView.h"
#import "SLBaseCollectionView.h"
#import "CategoryHeader.h"
#import "Masonry.h"

@interface SLPageContentView () <UICollectionViewDataSource, UICollectionViewDelegate>
/// 存储子控制器
@property (nonatomic, strong) NSArray <UIView *>*childViews;
/// collectionView
@property (nonatomic, strong) SLBaseCollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;

@end

@implementation SLPageContentView

- (instancetype)initWithChildViews:(NSArray <UIView *>*)childViews {
    if (self = [super init]) {
        self.childViews = childViews;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

+ (instancetype)pageContentViewWithChildViews:(NSArray<UIView *> *)childViews {
    return [[self alloc] initWithChildViews:childViews];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionViewFlowLayout.itemSize = self.bounds.size;
    [self.collectionView reloadData];
}

- (SLBaseCollectionView *)collectionView {
    if (!_collectionView) {
        self.collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionViewFlowLayout.itemSize = self.bounds.size;
        self.collectionViewFlowLayout.minimumLineSpacing = 0;
        self.collectionViewFlowLayout.minimumInteritemSpacing = 0;
        self.collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat collectionViewX = 0;
        CGFloat collectionViewY = 0;
        CGFloat collectionViewW = self.width;
        CGFloat collectionViewH = self.height;
        _collectionView = [[SLBaseCollectionView alloc] initWithFrame:CGRectMake(collectionViewX, collectionViewY, collectionViewW, collectionViewH) collectionViewLayout:self.collectionViewFlowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

#pragma mark - - - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childViews.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 设置内容
    UIView *childView = self.childViews[indexPath.item];
    childView.frame = cell.contentView.frame;
    [cell.contentView addSubview:childView];
    return cell;
}

#pragma mark - - - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger idx = (scrollView.contentOffset.x + self.bounds.size.width/2)/self.bounds.size.width;
    CGFloat progress = scrollView.contentOffset.x / self.width;
    if (self.pageScroll) {
        self.pageScroll(idx, progress);
    }
}

#pragma mark - - - 给外界提供的方法，获取 SGPageTitleView 选中按钮的下标
- (void)setCurrentIndex:(NSInteger)index{
    CGFloat offsetX = index * self.collectionView.width;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}



@end
