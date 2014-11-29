//
//  RequestMessage.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-30.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "RequestMessage.h"

@implementation RequestMessage
/**
 * @param Id
 * @param requestType
 **/
- (id)initWithId:(NSString *)Id requestType:(Byte)requestType
{
    self = [super init];
    if(self){
        self.Id = Id;
        self.requestType = requestType;
    }
    return self;
}
/**
 * @param requestType
 **/
- (id)initWithRequestType:(Byte)requestType{
    return [self initWithId:nil requestType:requestType];
}
/**
 * convert to data
 **/
- (NSData *)data{
    NSDictionary *dic = @{@"id":[Tools sEmpty:self.Id], @"requestType": [NSNumber numberWithUnsignedChar:self.requestType]};
    return dic.mp_messagePack;
}

@end
