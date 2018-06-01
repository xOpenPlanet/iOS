//
//  EFShareControllerViewController.h
//  ShareComps
//
//  Created by 虎 谢 on 2017/11/14.
//  Copyright © 2017年 谢虎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

@interface EFShareController : UIViewController


/**
 Appdelegate调用一下，初始化分享，注册相应平台的appid和key
 */
+(void)sharemanager;


/**
 调用分享的参数

 @param imageString 展示图片的地址
 @param title item的标题
 @param describe 描述
 @param targetUrl 点击跳转的地址
 @param success 成功回调
 @param failure 失败回调
 */

-(void)shareManegerWithImageString:(NSString *)imageString WithTitle:(NSString *)title WithDescribe:(NSString *)describe WithTargetUrl:(NSString *)targetUrl success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

@end
