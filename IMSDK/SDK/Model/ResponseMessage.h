//
//  ResponseMessage.h
//  IMSDK
//
//  Created by foreveross－bj on 14-10-30.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "Message.h"
/**
 * @author zhanglei
 *
 * @Date 2014年10月30日
 *
 * @Version 1.0
 *
 **/
@interface ResponseMessage : Message

#pragma mark -
#pragma mark - attribute
@property (nonatomic, assign) int code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) long responseTime;
@property (nonatomic, readonly) Byte TYPE_CODE;

#pragma mark -
#pragma mark - Initialized and Creating

/**
 * @param code
 *
 **/
- (id)initWithCode:(int)code;
/**
 * @param code
 * @param message
 * @param responseTime
 **/
- (id)initWithCode:(int)code message:(NSString *)message responseTime:(long)responseTime;
/**
 * @param Id
 * @param code
 * @param message
 * @param responseTime
 **/
- (id)initWithId:(NSString *)Id code:(int)code message:(NSString *)message responseTime:(long)responseTime;
@end
