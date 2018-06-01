//
//  SecurityManager.h
//  IOSESPBase
//
//  Created by Javor on 14-10-20.
//  Copyright (c) 2014年 JavorFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StubObject.h"

@interface SecurityManager : NSObject

///根据功能编号检查权限
+(BOOL)checkGNQXWithGNBH:(NSString *)gnbh;

///根据菜单StubObject检查权限
+(BOOL)checkGNQXWithStub:(StubObject *)stubObject;

@end
