//
//  GroupUserAddCmdMessage.h
//  IMSDK
//
//  Created by foreveross－bj on 14-10-30.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "CommandMessage.h"
/**
 * @param zhanglei
 *
 * @Date 2014年10月30日
 *
 * @Version 1.0
 *
 **/
@interface GroupUserAddCmdMessage : CommandMessage

#pragma mark -
#pragma mark - attribute
@property (nonatomic, readonly) Byte TYPE_CODE;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *optUser;
@property (nonatomic, strong) NSArray *users;

#pragma mark -
#pragma mark - Initialized and Creating
/**
 * @param groupId
 * @param optUser
 * @param users
 **/
- (id)initWithGroupId:(NSString *)groupId optUser:(NSString *)optUser users:(NSArray *)users;


@end
