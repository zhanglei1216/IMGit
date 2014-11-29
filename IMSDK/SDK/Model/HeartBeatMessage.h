//
//  HeartBeatMessage.h
//  IMSDK
//
//  Created by foreveross－bj on 14-10-30.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "Message.h"
/**
 * @author zhanglei
 *
 * @Date 2014年10月30日
 *
 * @Version 1.0
 *
 **/
@interface HeartBeatMessage : Message

#pragma mark -
#pragma mark - attribute
@property (nonatomic, readonly) Byte TYPE_CODE;

@end
