//
//  MobileFormatObject.h
//  IOSESPBase
//
//  Created by JavorFeng on 13-12-3.
//  Copyright (c) 2013年 JavorFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileFormatRow.h"
#import "MobileFormatCol.h"

@interface MobileFormatObject : NSObject

@property(nonatomic,retain)NSString *tableName;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSMutableArray *rows;
@property(nonatomic,retain)NSString *detailCol;
@property(nonatomic,retain)NSString *detailName;
@property(nonatomic,retain)NSString *groupCol;
@property(nonatomic,retain)NSString *groupName;
@property(nonatomic,retain)NSString *formHeadName;
@property(nonatomic,retain)NSString *formPartName;
@property(nonatomic,retain)NSString *formName;
@property(nonatomic,retain)NSMutableDictionary *dic;


-(void)addRow:(MobileFormatRow *) row;
-(void)putValue:(NSString *)value forKey:(NSString *)key;
-(NSString *)stringForKey:(NSString *)key withDefault:(NSString *)defaultValue;

@end
