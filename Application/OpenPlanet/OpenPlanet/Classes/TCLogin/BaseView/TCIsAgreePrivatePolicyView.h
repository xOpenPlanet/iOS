//
//  TCPrivateView.h
//  OpenPlanet
//
//  Created by 王胜利 on 2018/4/26.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkChainHeader.h"

@interface TCIsAgreePrivatePolicyView : UIView

/// 同意服务与隐私条款
@property (strong, nonatomic) UIButton *agreeAgreementButton;
/// 服务与隐私条款
@property (strong, nonatomic) UIButton *agreementButton;

@property (assign, nonatomic) BOOL isAgree;

@property (copy, nonatomic) VoidBlock agreeAgreementButtonActionBlock;
@property (copy, nonatomic) VoidBlock agreementButtonActionBlock;

@end
