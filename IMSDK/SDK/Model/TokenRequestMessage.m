//
//  TokenRequestMessage.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-31.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "TokenRequestMessage.h"

@implementation TokenRequestMessage
- (id)init{
    self = [super initWithRequestType:31];
    if (self) {
        _TYPE_CODE = 31;
    }
    return self;
}
/**
 * @param Id
 * @param token
 **/
- (id)initWithId:(NSString *)Id token:(NSString *)token{
    self = [self init];
    if (self) {
        self.Id = Id;
        self.token = token;
    }
    return self;
}
/**
 * convert to data
 **/
- (NSData *)data{
    NSDictionary *dic = @{@"id":[Tools sEmpty:self.Id], @"requestType": [NSNumber numberWithUnsignedChar:self.requestType], @"token":[Tools sEmpty:self.token]};
    
    return dic.mp_messagePack;
}
@end
