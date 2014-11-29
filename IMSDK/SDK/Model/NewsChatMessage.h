//
//  NewsChatMessage.h
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
@interface NewsChatMessage : ChatMessage
#pragma mark -
#pragma mark - attribute
@property (nonatomic, readonly) Byte TYPE_CODE;
@property (nonatomic, assign) int articleCount;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *descriptions;
@property (nonatomic, strong) NSArray *picUrls;
@property (nonatomic, strong) NSArray *urls;

#pragma mark -
#pragma mark - Initialized and Creating
/**
 * @param Id
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
