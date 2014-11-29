//
//  RequestMessage.h
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
@interface RequestMessage : Message

#pragma mark -
#pragma mark - attribute
@property (nonatomic, assign) Byte requestType;

#pragma mark -
#pragma mark - Initialized and Creating
/**
 * @param requestType
 **/
- (id)initWithRequestType:(Byte)requestType;

/**
 * @param Id
 * @param requestType
 **/
- (id)initWithId:(NSString *)Id  requestType:(Byte)requestType;

@end
