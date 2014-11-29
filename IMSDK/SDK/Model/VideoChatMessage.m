//
//  VideoChatMessage.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-31.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "VideoChatMessage.h"

@implementation VideoChatMessage
/**
 * @param Id
 * @param to
 * @param from
 * @param timestamp
 **/

- (id)initWithId:(NSString *)Id to:(NSString *)to from:(NSString *)from timestap:(long)timestap{
    self = [super initWithMsgType:14 Id:Id to:to from:from timestap:timestap];
    if (self) {
        _TYPE_CODE = 14;
    }
    return self;
}

/**
 * @param Id
 **/
- (id)initWithId:(NSString *)Id{
    return [self initWithId:Id to:nil from:nil timestap:0];
}
- (id)init{
    return [self initWithId:nil];
}
/**
 * convert to data
 **/
- (NSData *)data{
    NSDictionary *dic = @{@"id":[Tools sEmpty:self.Id], @"msgType":[NSNumber numberWithUnsignedChar:self.msgType], @"from":[Tools sEmpty:self.from], @"to": [Tools sEmpty:self.to], @"mediaId":[Tools sEmpty:self.mediaId], @"title":[Tools sEmpty:self.title], @"description":[Tools sEmpty:self.Description], @"playTime":@(self.playTime), @"timestamp":@(self.timestamp)};
    return dic.mp_messagePack;
}
@end
