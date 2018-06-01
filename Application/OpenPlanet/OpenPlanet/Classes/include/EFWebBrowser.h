//
//  EFBrowser.h
//  WebSystem
//
//  Created by Javor on 16/12/14.
//  Copyright © 2016年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"

@protocol WebBrowserDelegate;

@interface EFWebBrowser : UIView <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, weak) id<WebBrowserDelegate> delegate;

@property (nonatomic, weak) NSString *URLString;


- (void)loadURL:(NSURL *)URL;
- (void)loadURLString:(NSString *)URLString;
- (void)loadFileURLString:(NSString *)filetring allowingReadAccessToURLString:(NSString *)readAccessToURLString;
- (void)invokeOSPJavaScript:(id)data responseCallback:(EFJBResponseCallback)responseCallback;

-(BOOL)canGoBack;
-(void)goBack;

@end


@protocol WebBrowserDelegate <NSObject>

@optional
- (void)webBrowser:(EFWebBrowser *)webBrowser didStartLoadingURL:(NSURL *)URL;
- (void)webBrowser:(EFWebBrowser *)webBrowser didFinishLoadingURL:(NSURL *)URL;
- (void)webBrowser:(EFWebBrowser *)webBrowser didFailToLoadURL:(NSURL *)URL error:(NSError *)error;
- (void)webBrowserDidCrash;
- (void)webBrowser:(EFWebBrowser *)webBrowser fakeProgressStartLoadingWithMessage:(NSString *)message;
- (void)webBrowserFakeProgressStopLoading;
- (void)webBrowser:(EFWebBrowser *)webBrowser didReceiveMessage:(NSString *)message;
- (void)webBrowser:(EFWebBrowser *)webBrowser didLoadTitle:(NSString *)title;


@end
