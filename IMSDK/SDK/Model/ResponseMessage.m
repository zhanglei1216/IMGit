//
//  ResponseMessage.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-30.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "ResponseMessage.h"

@implementation ResponseMessage
- (instancetype)init
{
    self = [super init];
    if (self) {
        _TYPE_CODE = 41;
    }
    return self;
}
/**
 * @param Id
 * @param code
 * @param message
 * @param responseTime
 **/
- (id)initWithId:(NSString *)Id code:(int)code message:(NSString *)message responseTime:(long)responseTime
{
    self = [self init];
    if (self) {
        self.Id = Id;
        self.code = code;
        self.message = message;
        self.responseTime = responseTime;
    }
    return self;
}
/**
 * @param code
 * @param message
 * @param responseTime
 **/
- (id)initWithCode:(int)code message:(NSString *)message responseTime:(long)responseTime
{
    return [self initWithId:nil code:code message:message responseTime:responseTime];
}
/**
 * @param code
 *
 **/
- (id)initWithCode:(int)code
{
    return [self initWithCode:code message:nil responseTime:0];
}
/**
 * convert to data
 **/
- (NSData *)data
{
    NSDictionary *dic = @{@"id":[Tools sEmpty:self.Id], @"code":@(self.code), @"message":[Tools sEmpty:self.message], @"responseTime":@(self.responseTime)};
    return dic.mp_messagePack;
}


@end
