//
//  TextChatMessage.h
//  IMSDK
//
//  Created by foreveross－bj on 14-10-31.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "ChatMessage.h"
/**
 * @param zhanglei
 *
 * @Date 2014年10月30日
 *
 * @Version 1.0
 *
 **/
@interface TextChatMessage : ChatMessage
#pragma mark -
#pragma mark - attribute
@property (nonatomic, readonly) Byte TYPE_CODE;
@property (nonatomic, strong) NSString *content;

#pragma mark -
#pragma mark - Initialized and Creating
/**
 * @param id
 * @param to
 * @param from
 * @param timestamp
 **/
- (id)initWithId:(NSString *)Id to:(NSString *)to from:(NSString *)from timestap:(long)timestap;
/**
 * @param Id
 **/
- (id)initWithId:(NSString *)Id;
@end
