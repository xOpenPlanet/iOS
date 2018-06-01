//
//  SystemShareWebUrlView.m
//  Share
//
//  Created by 高建飞 on 2018/5/30.
//  Copyright © 2018年 wsl. All rights reserved.
//

#import "SystemShareWebUrlView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface SystemShareWebUrlView()<UIWebViewDelegate>

@property (nonatomic, strong) UILabel *webTitleLabel;
@property (nonatomic, strong) UILabel *webUrlLabel;
@property (nonatomic, strong) UIImageView *webIconImageView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString * webUrl;

@end

@implementation SystemShareWebUrlView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void) createView {
    [self.webIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).inset(10);
        make.left.equalTo(self).with.offset(10);
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(70);
    }];
    [self.webTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).inset(5);
        make.right.equalTo(self).with.offset(-10);
        make.left.equalTo(self.webIconImageView.mas_right).with.offset(10);
        make.height.lessThanOrEqualTo(@35);
    }];
    [self.webUrlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.webTitleLabel.mas_bottom).offset(0);
        make.bottom.equalTo(self).inset(8);
        make.right.equalTo(self).with.offset(-10);
        make.left.equalTo(self.webIconImageView.mas_right).with.offset(10);
        make.height.mas_equalTo(35);
    }];
}

- (void) loadWebWithUrl:(NSString *)url {
    self.webUrl = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    self.webTitleLabel.text = @"网页标题";
    self.webUrlLabel.text = url;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    /* 获取网页标题 */
    NSString *htmlTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.webTitleLabel.text = htmlTitle;
    /* 获取网页内容 */
    NSString *content = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
    if(content.length >140) {
        content = [content substringToIndex:140];
    }
    self.webUrlLabel.text = self.webUrl;
    /* 获取网页域名 */
    NSString *hostName = [webView stringByEvaluatingJavaScriptFromString:@"document.location.hostname"];
    NSString *protocolName = [webView stringByEvaluatingJavaScriptFromString:@"document.location.protocol"];
    [self.webIconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@//%@/favicon.ico",protocolName, hostName]] placeholderImage:[UIImage imageNamed:@"chat_webdefaut.png"]];
    if(self.delegate && [self.delegate respondsToSelector:@selector(webViewDidFinishWithWebInfo:)]){
        NSDictionary *info = @{@"url": self.webUrl, @"title": htmlTitle, @"icon": [NSString stringWithFormat:@"%@//%@/favicon.ico",protocolName, hostName], @"subTitle": content,};
        [self.delegate webViewDidFinishWithWebInfo:info];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.webTitleLabel.text = @"";
    self.webUrlLabel.text = @"";
    self.webIconImageView.image = [UIImage imageNamed:@"chat_webdefaut.png"];
    if(self.delegate && [self.delegate respondsToSelector:@selector(webViewDidFinishWithWebInfo:)]){
        NSDictionary *info = @{@"url": self.webUrl, @"title": @"", @"icon": @"", @"subTitle": @"",};
        [self.delegate webViewDidFinishWithWebInfo:info];
    }
}

- (UILabel *) webTitleLabel {
    if(!_webTitleLabel) {
        _webTitleLabel = [UILabel new];
        _webTitleLabel.font = [UIFont systemFontOfSize:16];
        _webTitleLabel.numberOfLines = 2;
        [self addSubview:_webTitleLabel];
    }
    return _webTitleLabel;
}

- (UILabel *) webUrlLabel {
    if(!_webUrlLabel) {
        _webUrlLabel = [UILabel new];
        _webUrlLabel.textColor = [UIColor grayColor];
        _webUrlLabel.font = [UIFont systemFontOfSize:14];
        _webUrlLabel.numberOfLines = 2;
        [self addSubview:_webUrlLabel];
    }
    return _webUrlLabel;
}

- (UIImageView *) webIconImageView {
    if(!_webIconImageView) {
        _webIconImageView = [UIImageView new];
        _webIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_webIconImageView];
        _webIconImageView.image = [UIImage imageNamed:@"chat_webdefaut.png"];
    }
    return _webIconImageView;
}

- (UIWebView *) webView {
    if(!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
    }
    return _webView;
}

@end
