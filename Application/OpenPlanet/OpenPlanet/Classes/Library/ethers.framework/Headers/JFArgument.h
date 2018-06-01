//
//  JFArgument.h
//  ethers
//
//  Created by Javor Feng on 2018/3/10.
//  Copyright © 2018年 Ethers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFArgument : NSObject

typedef enum{
    /**int*/
    argumentType_int = 0,
    /**bool*/
    argumentType_bool = 1,
    /**string*/
    argumentType_string = 2,
    /**array*/
    argumentType_array = 3,
}argumentType;

@property(nonatomic, assign) NSInteger argumentType;
@property(nonatomic, assign) id argumentValue;

@end
