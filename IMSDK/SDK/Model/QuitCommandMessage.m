//
//  QuitCommandMessage.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-31.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "QuitCommandMessage.h"

@implementation QuitCommandMessage
- (id)init{
    self = [super initWithCommType:51];
    if (self) {
        _TYPE_CODE = 51;
        self.Id = [NSUUID UUID].UUIDString;
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
