//
//  MobileFormatRow.h
//  IOSESPBase
//
//  Created by JavorFeng on 13-12-3.
//  Copyright (c) 2013年 JavorFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileFormatCol.h"

@interface MobileFormatRow : NSObject

@property(nonatomic,retain) NSMutableArray *cols;

-(void)addcol:(MobileFormatCol *) col;
-(int)getColCount;

@end
