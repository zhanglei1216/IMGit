//
//  TokenRequestMessage.h
//  IMSDK
//
//  Created by foreveross－bj on 14-10-31.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "RequestMessage.h"
/**
 * @param zhanglei
 *
 * @Date 2014年10月30日
 *
 * @Version 1.0
 *
 **/
@interface TokenRequestMessage : RequestMessage

#pragma mark -
#pragma mark - attribute
@property (nonatomic, readonly)Byte TYPE_CODE;
@property (nonatomic, strong) NSString *token;

#pragma mark -
#pragma mark - Initialized and Creating
/**
 * @param Id
 * @param token
 **/
- (id)initWithId:(NSString *)Id token:(NSString *)token;
@end
