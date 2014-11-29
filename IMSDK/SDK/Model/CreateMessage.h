//
//  CreateMessage.h
//  IMSDK
//
//  Created by foreveross－bj on 14-11-4.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageHeader.h"
#import "Socket.h"

@interface CreateMessage : NSObject
/**
 * @param data
 * @return NSDictionary
 * 返回字典包含两个键值对{type:消息类型, message:消息对象}
 *
 **/
+ (Message *)messageWithData:(NSData *)data type:(SendMessageType)type error:(NSError **)error;

@end
