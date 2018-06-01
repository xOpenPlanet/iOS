//
//  TCChosePlanetController.m
//
//
//  Created by YRH on 2018/4/20.
//  Copyright © 2018年 YRH. All rights reserved.
//

#import "TCChosePlanetController.h"
#import "Masonry.h"
#import "Constant.h"
#import "TCPlanetCell.h"
#import "TCPlanetInfoModel.h"
#import "TalkChainHeader.h"
#import "TCSMSController.h"

#define kBundlePath [[NSBundle mainBundle] pathForResource:@"Planet.bundle" ofType:nil]
#define kPlanetSpace 0

@interface TCChosePlanetController () <UICollectionViewDelegate, UICollectionViewDataSource>
/// 返回按钮
@property (strong, nonatomic) UIButton * backButton;
/// 标题
@property (nonatomic, strong) UIView *titleView;
/// 滑动视图
@property (nonatomic, strong) UICollectionView *collectionView;
/// 星空背景
@property (nonatomic, strong) UIImageView *starrySkyImageView;
/// 太阳背景
@property (nonatomic, strong) UIImageView *sunImageView;
/// 星球名字
@property (nonatomic, strong) UILabel *planetNameLabel;
/// 简介
@property (nonatomic, strong) UITextView *introductionTextView;
/// 入住按钮
@property (nonatomic, strong) UIButton *stayInButton;

/// 比例
@property (nonatomic, assign) CGFloat proportion;
@property (nonatomic, assign) CGFloat starrySkyOffset;
/// 行星数组
@property (nonatomic, strong) NSMutableArray <TCPlanetInfoModel *>*planetInfoArray;
@property (nonatomic, strong) UIImage *sunStarImage;
@property (nonatomic, assign) NSUInteger currentSelectedCellIndex;

@end

static NSString *planetCell = @"planetCell";

@implementation TCChosePlanetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewDarkBackgroundColor" fromDictName:@"login"];
    self.view.clipsToBounds = YES;
    [self createData];
    [self createView];
    [self sunRotatingAnimation];
    [self changePlanetShowInfo];
    [self backButton];
}

#pragma mark - data
- (void)createData {
    _currentSelectedCellIndex = 0;
    NSMutableArray *planetArray = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/Planet/PlanetInformation.plist", kBundlePath]];
    [planetArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        TCPlanetInfoModel *planetModel = [TCPlanetInfoModel new];
        [planetModel setValuesForKeysWithDictionary:dic];
        planetModel.planetImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Planet/SolarSystem/%@", kBundlePath, dic[@"imageName"]]];
        [self.planetInfoArray addObject:planetModel];
    }];
    _sunStarImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Planet/Star/Sun.png", kBundlePath]];
}

#pragma mark - createView
- (void)createView {
    // 星空背景
    [self.starrySkyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.bottom.equalTo(self.view);
        }
        make.left.equalTo(self.view);
        make.width.equalTo(_starrySkyImageView.mas_height).multipliedBy(_proportion);
    }];

    // 标题
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view);
        }
        make.left.right.equalTo(self.view);
    }];
    // 太阳
    [self.sunImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(kScreenWidth * 2));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.introductionTextView.mas_bottom).offset(-20);
    }];

    // 入住按钮
    [self.stayInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_starrySkyImageView.mas_bottom).offset(-10);
        make.right.equalTo(_titleView.mas_right).offset(-10);
        make.left.equalTo(_titleView.mas_left).offset(10);
        make.height.equalTo(@45);
    }];
    // 简介
    [self.introductionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(_stayInButton);
        make.bottom.equalTo(_stayInButton.mas_top).offset(-10);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.15);
    }];
    // 星球名字
    [self.planetNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(_introductionTextView.mas_top).offset(-10);
    }];

    // 星球
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleView);
        make.top.equalTo(_titleView.mas_bottom);
        make.bottom.equalTo(_planetNameLabel.mas_top).offset(-10);
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_introductionTextView setContentOffset:CGPointZero];
    CGFloat starrySkyWidth = CGRectGetWidth(_starrySkyImageView.frame);
    _starrySkyOffset = (starrySkyWidth - kScreenWidth) / self.planetInfoArray.count;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.planetInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCPlanetInfoModel *planetModel = self.planetInfoArray[indexPath.row];
    TCPlanetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:planetCell forIndexPath:indexPath];
    cell.cellImage = planetModel.planetImage;
    return cell;
}

#pragma mark - 改变星球描述信息
- (void)changePlanetShowInfo {
    if (_currentSelectedCellIndex < self.planetInfoArray.count) {
        TCPlanetInfoModel *planetModel = self.planetInfoArray[_currentSelectedCellIndex];
        _planetNameLabel.text = planetModel.name;
        _introductionTextView.text = planetModel.information;
    }
}

#pragma mark - 太阳转圈动画
- (void)sunRotatingAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI * 2];
    animation.duration = 150.0f;
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    [_sunImageView.layer addAnimation:animation forKey:nil];
}

#pragma mark - scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat offset = offsetX / kScreenWidth * _starrySkyOffset;
    if (offsetX < 0 || offsetX > kScreenWidth * self.planetInfoArray.count) {
        return;
    }
    [_starrySkyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(-offset);
    }];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX / kScreenWidth;
    if (page != _currentSelectedCellIndex) {
        _currentSelectedCellIndex = page;
        // 展示当前星球信息
        [self changePlanetShowInfo];
    }
}

- (void)nextAction{
    TCSMSController *vc = [TCSMSController new];
    vc.areaCode = self.areaCode;
    vc.phone = self.phone;
    vc.type = TCSMSTypeRegister;
    vc.inviteCode = self.inviteCode;
    vc.planetEnName = self.planetInfoArray[_currentSelectedCellIndex].enName;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - lazy
// 标题
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        [self.view addSubview:_titleView];
        // 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        [_titleView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_titleView.mas_centerX);
            make.left.right.equalTo(_titleView);
            make.top.equalTo(_titleView.mas_top).offset(10);
        }];
        // 副标题
        UILabel *subtitleLabel = [[UILabel alloc] init];
        [_titleView addSubview:subtitleLabel];
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(5);
            make.left.right.equalTo(_titleView);
            make.centerX.equalTo(_titleView.mas_centerX);
            make.bottom.equalTo(_titleView.mas_bottom).offset(-10);
        }];
        titleLabel.text = @"请选择您要入住的星球";
        subtitleLabel.text = @"(选择以后将不可更改)";
        titleLabel.textAlignment = subtitleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        subtitleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"labelBrightTextColor" fromDictName:@"login"];
        subtitleLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"labelTextColor" fromDictName:@"login"];
    }
    return _titleView;
}

// 太阳背景
- (UIImageView *)sunImageView {
    if (!_sunImageView) {
        _sunImageView = [[UIImageView alloc] init];
        [self.starrySkyImageView addSubview:_sunImageView];
        _sunImageView.image = _sunStarImage;
    }
    return _sunImageView;
}

// 星空背景
- (UIImageView *)starrySkyImageView {
    if (!_starrySkyImageView) {
        _starrySkyImageView = [[UIImageView alloc] init];
        [self.view addSubview:_starrySkyImageView];
        _starrySkyImageView.clipsToBounds = YES;
        UIImage *starrySkyImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Planet/StarrySky/StarrySkyBackground.png", kBundlePath]];
        _proportion = starrySkyImage.size.width / starrySkyImage.size.height;
        _starrySkyImageView.image = starrySkyImage;
    }
    return _starrySkyImageView;
}

// 星球名字
- (UILabel *)planetNameLabel {
    if (!_planetNameLabel) {
        _planetNameLabel = [[UILabel alloc] init];
        [self.view addSubview:_planetNameLabel];
        _planetNameLabel.textAlignment = NSTextAlignmentCenter;
        _planetNameLabel.theme_textColor = [UIColor theme_colorPickerForKey:@"labelBrightTextColor" fromDictName:@"login"];
        [_planetNameLabel sizeToFit];
    }
    return _planetNameLabel;
}

// 简介
- (UITextView *)introductionTextView {
    if (!_introductionTextView) {
        _introductionTextView = [[UITextView alloc] init];
        [self.view addSubview:_introductionTextView];
        _introductionTextView.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewDarkAlphaBackgroundColor" fromDictName:@"login"];
        _introductionTextView.layer.cornerRadius = 5.0f;
        _introductionTextView.font = [UIFont systemFontOfSize:14];
        _introductionTextView.editable = NO;
        _introductionTextView.theme_textColor = [UIColor theme_colorPickerForKey:@"labelTextColor" fromDictName:@"login"];
        _introductionTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return _introductionTextView;
}

// 入住按钮
- (UIButton *)stayInButton {
    if (!_stayInButton) {
        _stayInButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.view addSubview:_stayInButton];
        [_stayInButton setTitle:@"入住星球" forState:(UIControlStateNormal)];
        _stayInButton.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewDarkBackgroundColor" fromDictName:@"login"];
        _stayInButton.layer.cornerRadius = 5.0f;
        [_stayInButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stayInButton;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat space = kPlanetSpace;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kScreenWidth - space * 2, kScreenWidth - space * 2);
        layout.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
        layout.minimumLineSpacing = space * 2;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
        [_collectionView registerClass:[TCPlanetCell class] forCellWithReuseIdentifier:planetCell];
        _collectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    return _collectionView;
}

- (NSMutableArray *)planetInfoArray {
    if (!_planetInfoArray) {
        _planetInfoArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _planetInfoArray;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _backButton.tintColor = cWhiteColor;
        [_backButton setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
        [self.view insertSubview:_backButton aboveSubview:self.titleView];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.width.height.equalTo(@30);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            } else {
                make.top.equalTo(self.view ).offset(30);
            }
        }];
        [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _backButton;
}
@end

