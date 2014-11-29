//
//  ChatMessage.h
//  IMSDK
//
//  Created by foreveross－bj on 14-10-29.
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
@interface ChatMessage : Message

#pragma mark-
#pragma mark - attribute

@property (nonatomic, assign) Byte msgType;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, assign) long timestamp;


#pragma mark -
#pragma mark - Initialized and Creating
/**
 * @param msgType
**/
- (id)initWithMsgType:(Byte)msgType;

/**
 * @param msgType
 * @param Id
**/
- (id)initWithMsgType:(Byte)msgType Id:(NSString*)Id;

/**
 * @param msgType
 * @param Id
 * @param to
 * @param from
 * @param timestap
**/
- (id)initWithMsgType:(Byte)msgType Id:(NSString *)Id to:(NSString *)to from:(NSString *)from timestap:(long)timestap;


@end
