//
//  HeartBeatMessage.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-30.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "HeartBeatMessage.h"

@implementation HeartBeatMessage
- (id)init{
    self = [super init];
    if (self) {
        _TYPE_CODE = 21;
        self.Id = [NSUUID UUID].UUIDString;
    }
    return self;
}

- (NSData *)data
{
    NSDictionary *dic = @{@"id":[Tools sEmpty:self.Id]};
    return dic.mp_messagePack;
}
@end
