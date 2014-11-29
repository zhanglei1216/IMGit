//
//  GroupUserDelCmdMessage.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-31.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "GroupUserDelCmdMessage.h"

@implementation GroupUserDelCmdMessage
- (id)init{
    self = [super initWithCommType:53];
    if (self) {
        _TYPE_CODE = 53;
    }
    return self;
}
/**
 * @param groupId
 * @param optUser
 * @param users
 **/
- (id)initWithGroupId:(NSString *)groupId optUser:(NSString *)optUser users:(NSArray *)users{
    self = [self init];
    if (self) {
        self.groupId = groupId;
        self.optUser = optUser;
        self.users = users;
    }
    return self;
}
/**
 * override
 **/
- (NSUInteger)hash{
    const int prime = 31;
    NSUInteger result = super.hash;
    result = prime * result + ((_groupId == nil) ? 0 : _groupId.hash);
    result = prime * result + ((_optUser == nil) ? 0 : _optUser.hash);
    result = prime * result + _users.hash;
    return result;
}
/**
 * override
 **/
- (BOOL)isEqual:(id)object{
    if (self == object)
        return true;
    if (![super isEqual:object])
        return false;
    if ([self class] != [object class])
        return false;
    GroupUserDelCmdMessage *other = (GroupUserDelCmdMessage *) object;
    if (_groupId == nil) {
        if (other.groupId != nil)
            return false;
    } else if (![_groupId isEqualToString:other.groupId])
        return false;
    if (_optUser == nil) {
        if (other.optUser != nil)
            return false;
    } else if (![_optUser isEqualToString:other.optUser])
        return false;
    if (! [_users isEqualToArray:other.users])
        return false;
    return true;
}
/**
 * override
 **/
- (NSString *)description{
    return [NSString stringWithFormat:@"GroupUserDelCmdMessage [groupId=%@, optUser=%@, , users=%@, %@]", _groupId, _optUser, _users.description, super.description];
}

/**
 * convert to data
 **/
- (NSData *)data{
    NSDictionary *dic = @{@"id":[Tools sEmpty:self.Id], @"commType":[NSNumber numberWithUnsignedChar:self.commType], @"groupId":[Tools sEmpty:self.groupId],@"optUser":[Tools sEmpty:self.optUser], @"users":[Tools aEmpty:self.users]};
    return dic.mp_messagePack;
}
@end
