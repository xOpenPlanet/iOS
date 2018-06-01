//
//  EFContentScrollView.h
//  ESPChatComps
//
//  Created by 虎 谢 on 2017/1/5.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StubObject.h"
#import "EFWebBrowser.h"
@interface EFContentScrollView : UIScrollView<WebBrowserDelegate, UIScrollViewDelegate>

@property(nonatomic,copy)NSString  *htmlpath;

@property(nonatomic,strong)StubObject *dataStub;

@property(nonatomic,strong) NSMutableDictionary *tabDic;

-(instancetype)init;

@end
