//
//  JFQueue.h
//  IOSESPBase
//
//  Created by Javor on 16/12/1.
//  Copyright © 2016年 JavorFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFQueue : NSObject

- (BOOL)offer:(id)object;
- (id)peek;
- (void)poll;
- (void)empty;

@end
