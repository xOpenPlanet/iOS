//
//  RegistryUtil.h
//  IOSESPBase
//
//  Created by JavorFeng on 13-11-30.
//  Copyright (c) 2013年 JavorFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StubObject.h"
#import "GDataXMLNode.h"

@interface RegistryUtil : NSObject

+(void)createRegistryWithXMLRootElement : (GDataXMLElement *) rootElement;
+(void)addStubObjectPropWithStubObject : (StubObject *) stubObject node : (GDataXMLElement *) node;
+(void)dealNodeWithParentNode : (GDataXMLElement *) parentNode parentStubObj : (StubObject *) parentStubObj;
+(void)procPackageWithXML:(NSString *)xml;
+(void)procAPPPackageWithXML:(NSString *)xml;

@end
