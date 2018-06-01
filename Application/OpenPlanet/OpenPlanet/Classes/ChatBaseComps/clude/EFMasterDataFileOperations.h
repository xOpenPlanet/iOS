//
//  EFMasterDataFileOperations.h
//  ESPChatComps
//
//  Created by 于仁汇 on 2017/9/13.
//  Copyright © 2017年 Pansoft. All rights reserved.
//

/*
 应用号更新主数据操作类
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 0:全量;1:增加;2:删除;3:变更
typedef enum : NSUInteger {
    ReplaceAllOperation,
    AddSeveralContentOperation,
    DeleteSeveralContentOperation,
    ReplaceSeveralContentOperation,
} FileOperation;

@interface EFMasterDataFileOperations : NSObject

+ (BOOL)masterDataFileReplaceCertainFileWithFilePath:(NSString *)filePath fileName:(NSString *)fileName newFileData:(NSData *)fileData;
+ (BOOL)masterDataFileReviseContentDataWithFilePath:(NSString *)filePath fileName:(NSString *)fileName needRevisingContentArray:(NSArray *)revisingContentArray fileOperation:(FileOperation)fileOperation tableName:(NSString *)tableName majorKeys:(NSArray *)majorKeys;

@end
