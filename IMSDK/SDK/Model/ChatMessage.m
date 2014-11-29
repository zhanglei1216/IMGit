//
//  ChatMessage.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-29.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage
/**
 * @param msgType
 * @param Id
 * @param to
 * @param from
 * @param timestap
 **/
- (id)initWithMsgType:(Byte)msgType Id:(NSString *)Id to:(NSString *)to from:(NSString *)from timestap:(long)timestap
{
    self = [super init];
    if (self) {
        self.msgType = msgType;
        self.Id = Id;
        self.to = to;
        self.from = from;
        self.timestamp = timestap;
    }
    return self;
}
/**
 * @param msgType
 **/
- (id)initWithMsgType:(Byte)msgType
{
    return [self initWithMsgType:msgType Id:nil to:nil from:nil timestap:0];
}
/**
 * @param msgType
 * @param Id
 **/
- (id)initWithMsgType:(Byte)msgType Id:(NSString *)Id
{
    return [self initWithMsgType:msgType Id:Id to:nil from:nil timestap:0];
}
/**
 * convert to data
 **/
- (NSData *)data{
    NSDictionary *dic = @{@"id":[Tools sEmpty:self.Id], @"msgType":[NSNumber numberWithUnsignedChar:self.msgType], @"from":[Tools sEmpty:self.from], @"to": [Tools sEmpty:self.to], @"timestamp":@(self.timestamp)};
    return dic.mp_messagePack;
}
@end
