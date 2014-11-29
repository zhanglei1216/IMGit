//
//  ReceiptCmdMessage.h
//  IMSDK
//
//  Created by foreveross－bj on 14-10-31.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "CommandMessage.h"
/**
 *已读回执
 *
 * @param zhanglei
 *
 * @Date 2014年10月30日
 *
 * @Version 1.0
 *
 **/
@interface ReceiptCmdMessage : CommandMessage

#pragma mark -
#pragma mark - attribute
@property (nonatomic, readonly) Byte TYPE_CODE;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, assign) long timestamp;
@property (nonatomic, strong) NSDictionary *messages;

#pragma mark -
#pragma mark - Initialized and Creating
/**
 * @param from
 * @param to
 * @param timestamp
 * @param messages
 **/
- (id)initWithFrom:(NSString *)from to:(NSString *)to timestamp:(long)timestamp messages:(NSDictionary *)messages;

@end
