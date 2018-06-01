//
//  MobileFormatCol.h
//  IOSESPBase
//
//  Created by JavorFeng on 13-12-3.
//  Copyright (c) 2013年 JavorFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobileFormatCol : NSObject

@property(nonatomic, retain) NSString *caption;
@property(nonatomic, retain) NSString *dataSetColID;
@property(nonatomic, retain) NSString *viewDataSetID;
@property(nonatomic, retain) NSString *viewDataSetColID;
@property(nonatomic, retain) NSString *mask;
@property(nonatomic, retain) NSString *foreignKey;
@property(nonatomic, retain) NSString *tabName;
@property(nonatomic, retain) NSString *icon;
@property(nonatomic, retain) NSString *selectIcon;
@property(nonatomic, retain) NSString *textAlign;               //对齐方式:left;center;right
@property(nonatomic, retain) NSString *columnType;              //列类型:"0:字符;1:数值;2:整数;3:日期"
@property(nonatomic, retain) NSString *numberPrecision;         //数值精度
@property(nonatomic, retain) NSString *textFormat;              //数值格式:"0:General;1:#,##0;2:0%"
@property(nonatomic, retain) NSString *dateFormat;              //日期格式:"YYYY-MM-DD" -->
@property(nonatomic, retain) NSMutableDictionary *dic;


-(void)putValue:(NSString *)value forKey:(NSString *)key;
-(NSString *)stringForKey:(NSString *)key withDefault:(NSString *)defaultValue;

@end

