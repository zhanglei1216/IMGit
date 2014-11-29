//
//  MenuEventChatMessage.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-31.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "MenuEventChatMessage.h"

@implementation MenuEventChatMessage
- (id)init{
    self = [super initWithMsgType:17];
    if (self) {
        _TYPE_CODE = 17;
    }
    return self;
}
/**
 * @param Id
 * @param key
 * @param to
 * @param from
 * @param timestamp
 **/
- (id)initWithId:(NSString *)Id key:(NSString *)key to:(NSString *)to from:(NSString *)from timestap:(long)timestap{
    self = [super initWithMsgType:17 Id:Id to:to from:from timestap:0];
    if (self) {
        _TYPE_CODE = 17;
        self.eventKey = key;
        self.eventType = 1;
    }
    return self;
}
/**
 * @param Id
 * @param to
 * @param from
 * @param timestamp
 **/

- (id)initWithId:(NSString *)Id to:(NSString *)to from:(NSString *)from timestap:(long)timestap{
    return [self initWithId:Id key:nil to:to from:from timestap:timestap];
}

/**
 * @param Id
 **/
- (id)initWithId:(NSString *)Id{
    self = [super initWithMsgType:17 Id:Id];
    if (self) {
        _TYPE_CODE = 17;
    }
    return self;
}
/**
 * convert to data
 **/
- (NSData *)data{
    NSDictionary *dic = @{@"id":[Tools sEmpty:self.Id], @"msgType":[NSNumber numberWithUnsignedChar:self.msgType], @"eventType":[NSNumber numberWithUnsignedInteger:self.eventType], @"eventKey":[Tools sEmpty:self.eventKey], @"from":[Tools sEmpty:self.from], @"to": [Tools sEmpty:self.to], @"timestamp":@(self.timestamp)};
    return dic.mp_messagePack;
}
@end
