//
//  ReceiptCmdMessage.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-31.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "ReceiptCmdMessage.h"

@implementation ReceiptCmdMessage
- (id)init{
    self = [super initWithCommType:54];
    if (self) {
        _TYPE_CODE = 54;
    }
    return self;
}
/**
 * @param from
 * @param to
 * @param timestamp
 * @param messages
 **/
- (id)initWithFrom:(NSString *)from to:(NSString *)to timestamp:(long)timestamp messages:(NSDictionary *)messages{
    self = [self init];
    if (self) {
        self.from = from;
        self.to = to;
        self.timestamp = timestamp;
        self.messages = messages;
    }
    return self;
}
/**
 * override
 **/
- (NSUInteger)hash{
    const int prime = 31;
    long long result = 1;
    result = prime * result + ((_from == nil) ? 0 : _from.hash);
    result = prime * result + ((_messages == nil) ? 0 : _messages.hash);
    result = prime * result + (long long) ((long long)_timestamp ^ ((long long)_timestamp >> 32));
    result = prime * result + ((_to == nil) ? 0 : _to.hash);
    return result;
}
/**
 * override
 **/
- (BOOL)isEqual:(id)object{
    if (self == object)
        return true;
    if (object == nil)
        return false;
    if ([self class] != [object class])
        return false;
    ReceiptCmdMessage *other = (ReceiptCmdMessage *) object;
    if (_from == nil) {
        if (other.from != nil)
            return false;
    } else if (![_from isEqualToString:other.from])
        return false;
    if (_messages == nil) {
        if (other.messages != nil)
            return false;
    } else if (![_messages isEqualToDictionary:other.messages])
        return false;
    if (_timestamp != other.timestamp)
        return false;
    if (_to == nil) {
        if (other.to != nil)
            return false;
    } else if (![_to isEqualToString:other.to])
        return false;
    return true;
}
/**
 * override
 **/
- (NSString *)description{
    return [NSString stringWithFormat:@"ReceiptCmdMessage [from=%@, to=%@, timestamp=%ld, messages=%@]", _from, _to, _timestamp, _messages.description];
}

/**
 * convert to data
 **/
- (NSData *)data{
    NSDictionary *dic = @{@"id":[Tools sEmpty:self.Id], @"commType":[NSNumber numberWithUnsignedChar:self.commType], @"from":[Tools sEmpty:self.from], @"to":[Tools sEmpty:self.to], @"messages":[Tools dEmpty:self.messages], @"timestamp":@(self.timestamp)};
    return dic.mp_messagePack;
}
@end
