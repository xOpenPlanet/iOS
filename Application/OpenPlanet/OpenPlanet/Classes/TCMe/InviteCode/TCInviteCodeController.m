//
//  TCInviteCodeController.m
//  TalkChain
//
//  Created by 王胜利 on 2018/3/21.
//  Copyright © 2018年 Javor Feng. All rights reserved.
//

#import "TCInviteCodeController.h"
#import "TalkChainHeader.h"
#import "TCInviteCodeView.h"
#import <CoreImage/CoreImage.h>
#import "EnvironmentVariable.h"
#import "Registry.h"

@interface TCInviteCodeController ()

@property (strong, nonatomic) TCInviteCodeView *rootView;

@end

@implementation TCInviteCodeController

- (void)loadView{
    self.view = self.rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请码";
    self.view.theme_backgroundColor = [UIColor theme_colorPickerForKey:@"viewBackgroud"];

    [self loadAppDownUrl];

    NSString *inviteCode = [EnvironmentVariable getPropertyForKey:@"inviteCode" WithDefaultValue:@"邀请码为空"];
    self.rootView.inviteCodeLabel.text = inviteCode;
}


#pragma mark - 拷贝邀请码
- (void)copyInviteCode{
    NSString *string = [NSString stringWithFormat:@"邀请码：%@,我是%@，邀请您加入开放星球。期待您的加入哦～～",SafeString(self.rootView.inviteCodeLabel.text),[EnvironmentVariable getUserName]];
    [UIPasteboard generalPasteboard].string = string;
    [self.view jk_makeToast:@"邀请码已复制"  duration:0.8f position:JKToastPositionCenter];
}

#pragma mark - 加载AppDownloadUrl
- (void)loadAppDownUrl{
    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSData *strData = [[self getDownloadUrl] dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:strData forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    self.rootView.qrImageView.image = [self getErWeiMaImageFormCIImage:outputImage withSize:200];
}

- (NSString *)getDownloadUrl{
    StubObject *stuObject = [Registry getStubObjectForKey:@"ipaurl"];
    return [stuObject getStringForKey:@"url" withDefaultValue:@""];
}

// 获取高清二维码图片
- (UIImage *)getErWeiMaImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));

    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyload
- (TCInviteCodeView *)rootView{
    if (!_rootView) {
        _rootView = [TCInviteCodeView new];
        _rootView.inviteCodeTitleLabel.text = @"您的邀请码";
        _rootView.inviteCodeLabel.text = @"邀请码为空";
        [_rootView.inviteCodeCopyButton setTitle:@"复制" forState:UIControlStateNormal];
        _rootView.rewardLabel.text = @"每邀请一位好友注册后，您将获取1000银钻奖励";
        _rootView.qrLabel.text = @"扫码下载开放星球";
        [_rootView.inviteCodeCopyButton addTarget:self action:@selector(copyInviteCode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rootView;
}

@end
