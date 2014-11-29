//
//  Message.h
//  IMSDK
//
//  Created by foreveross－bj on 14-10-29.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMessagePack.h"
#import "Tools.h"
/**
 *@author zhanglei
 *
 *@Date 2013年10月30日
 *
 *@Version 1.0
 **/
@interface Message : NSObject
{
    NSString *_id;
}
#pragma mark-
#pragma mark - attribute
@property (nonatomic, strong) NSString *Id;

#pragma mark -
#pragma mark - Initialized and Creating
/**
 * @param Id
 **/
- (id)initWithId:(NSString *)Id;

#pragma mark -
#pragma mark - function
/**
 * convert to data
 **/
- (NSData *)data;

@end

