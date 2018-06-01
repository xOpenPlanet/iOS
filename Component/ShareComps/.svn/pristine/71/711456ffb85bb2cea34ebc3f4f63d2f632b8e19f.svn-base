//
//  EFShareControllerViewController.m
//  ShareComps
//
//  Created by 虎 谢 on 2017/11/14.
//  Copyright © 2017年 谢虎. All rights reserved.
//

#import "EFShareController.h"
#import <UShareUI/UShareUI.h>

@interface EFShareController ()

@property (copy) void (^successBlcok)(id);
@property (copy) void (^failureBlock)(NSString *);

@end

@implementation EFShareController


+(void)sharemanager {
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5b0cadfb8f4a9d0a38000160"];
    
    
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
//        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx324eec6b67bfe8c3" appSecret:@"564b0fa42ffc6468cf40e4b6a6c39730" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106862075"/*设置QQ平台的appID*/  appSecret:@"KEYdSCBe6krC4Xvjaxo" redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone appKey:@"1106862075"/*设置QQ平台的appID*/  appSecret:@"KEYdSCBe6krC4Xvjaxo" redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1458637286"  appSecret:@"a784b85297d0912d182c4aecba14300a" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    /* 钉钉的appKey */
    //    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DingDing appKey:@"dingoalmlnohc0wggfedpk" appSecret:nil redirectURL:nil];
    //
    //    /* 支付宝的appKey */
    //    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:nil];
    //
    //    /* 设置易信的appKey */
    //    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_YixinSession appKey:@"yx35664bdff4db42c2b7be1e29390c1a06" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    //
    //    /* 设置点点虫（原来往）的appKey和appSecret */
    //    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_LaiWangSession appKey:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" redirectURL:@"http://mobile.umeng.com/social"];
    //
    //    /* 设置领英的appKey和appSecret */
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Linkedin appKey:@"81t5eiem37d2sc"  appSecret:@"7dgUXPLH8kA8WHMV" redirectURL:@"https://api.linkedin.com/v1/people"];
    //
    //    /* 设置Twitter的appKey和appSecret */
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:nil];
    //
    //    /* 设置Facebook的appKey和UrlString */
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"506027402887373"  appSecret:nil redirectURL:nil];
    //
    //    /* 设置Pinterest的appKey */
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Pinterest appKey:@"4864546872699668063"  appSecret:nil redirectURL:nil];
    //
    //    /* dropbox的appKey */
    //    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DropBox appKey:@"k4pn9gdwygpy4av" appSecret:@"td28zkbyb9p49xu" redirectURL:@"https://mobile.umeng.com/social"];
    //
    //    /* vk的appkey */
    //    [[UMSocialManager defaultManager]  setPlaform:UMSocialPlatformType_VKontakte appKey:@"5786123" appSecret:nil redirectURL:nil];
    
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite),
                                                                                @(UMSocialPlatformType_WechatSession),
                                                                                @(UMSocialPlatformType_WechatTimeLine)]];
}

-(void)shareManegerWithImageString:(NSString *)imageString WithTitle:(NSString *)title WithDescribe:(NSString *)describe WithTargetUrl:(NSString *)targetUrl success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure {
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        NSString* thumbURL =  imageString;
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:describe thumImage:thumbURL];
        //设置网页地址
        shareObject.webpageUrl = targetUrl;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
                failure(@"error");
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
                success(@"yes");
            }
        }];
    }];
}

@end
