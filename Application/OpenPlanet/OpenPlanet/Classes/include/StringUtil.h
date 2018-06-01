//
//  StringUtil.h
//  IOSESPBase
//
//  Created by JavorFeng on 13-12-3.
//  Copyright (c) 2013年 JavorFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtil : NSObject

/** 是否包含字符串 */
+(BOOL)contains:(NSString*)res findString:(NSString *) findString;

/** trim */
+(NSString *)trimString:(NSString *)originalString;

//生成随机字符串
+(NSString *)randomStringWithLength:(int)length;

/**
 * 字符串填充函数.生成一定长度用某字符填充的字符串
 * @param     psStr    要进行处理的参数字符串
 * @param     psLen    返回字符串的长度
 * @param     psC      填充的字符串
 * @return    string   填充后的字符串
 */
+(NSString *)fillString:(NSString *)psStr withChar:(NSString *)psC length:(int)psLen;

/**  MD5加密 */
+(NSString *)encodeWithMD5:(NSString *)eStr;
+ (NSString *)changeDateString:(NSString *)Str;
@end


@interface NSString (Util)
/** 去掉空格 */
-(NSString *)trimString;
@end
