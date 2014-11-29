//
//  ImageChatMessage.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-31.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "ImageChatMessage.h"

@implementation ImageChatMessage
/**
 * @param Id
 * @param to
 * @param from
 * @param timestamp
 **/
- (id)initWithId:(NSString *)Id from:(NSString *)from to:(NSString *)to timestamp:(long)timestamp{
    self = [super initWithMsgType:12 Id:Id to:to from:from timestap:timestamp];
    if (self) {
        _TYPE_CODE = 12;
    }
    return self;
}
/**
 * @param Id
 **/
- (id)initWithId:(NSString *)Id{
    return [self initWithId:Id from:nil to:nil timestamp:0];
}
- (id)init{
    return [self initWithId:nil];
}

/**
 * convert to data
 **/
- (NSData *)data{
    NSDictionary *dic = @{@"id":[Tools sEmpty:self.Id], @"msgType":[NSNumber numberWithUnsignedChar:self.msgType], @"from":[Tools sEmpty:self.from], @"to": [Tools sEmpty:self.to], @"thumbContent":[Tools bEmpty:self.thumbContent], @"timestamp":@(self.timestamp)};
    return dic.mp_messagePack;
}
@end
