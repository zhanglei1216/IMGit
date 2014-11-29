//
//  CommandMessage.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-30.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "CommandMessage.h"

@implementation CommandMessage
/**
 * @param commType
 **/
- (id)initWithCommType:(Byte)commType{
    self = [super init];
    if (self) {
        self.commType = commType;
    }
    return self;
}
/**
 * convert to data
 **/
- (NSData *)data{
    NSDictionary *dic = @{@"id":[Tools sEmpty:self.Id], @"commType":[NSNumber numberWithUnsignedChar:self.commType]};
    return dic.mp_messagePack;
}
@end
