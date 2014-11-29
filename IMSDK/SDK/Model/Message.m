//
//  Message.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-29.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "Message.h"

@implementation Message
@synthesize Id = _id;

/**
 * @param Id
 **/
- (id)initWithId:(NSString *)Id{
    self = [super init];
    if (self) {
        self.Id = Id;
    }
    return self;
}


/**
 * convert to data
 **/
- (NSData *)data{
    NSDictionary *dic = @{@"id":[Tools sEmpty:self.Id]};
    return dic.mp_messagePack;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
