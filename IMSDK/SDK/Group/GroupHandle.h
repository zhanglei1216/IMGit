//
//  GroupHandle.h
//  IMSDK
//
//  Created by foreveross－bj on 14-11-21.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum GroupQueryMemberType{
    GroupQueryMemberUid,
    GroupQueryMemberAccount,
}QueryMemberType;
#pragma mark -
#pragma mark - protocol
@protocol groupDelegate <NSObject>

@optional
/**
 * @param optId
 * @param ids
 * @param tag
 **/
- (void)groupWillCreateWithOptId:(NSString *)optId ids:(NSArray *)ids;
/**
 * @param optId
 * @param gid
 * @param ids
 * @param tag
 **/
- (void)groupDidCreateSuccessOptId:(NSString *)optId ids:(NSArray *)ids result:(NSDictionary *)result;
/**
 * @param type
 * @param reason
 * @param tag
 **/
- (void)groupDidCreateFailWithType:(int)type reason:(NSString *)reason;
/**
 * @optId
 **/
- (void)groupWillGetUserGroupsInfoWithOptId:(NSString *)optId;
/**
 * @param info
 **/
- (void)groupDidGetUserGroupsSuccessWithOptId:(NSString *)optId Info:(NSArray *)info;
/**
 * @param type
 * @paramm reason
 **/
- (void)groupDidGetUserGroupsInfoFailWithType:(int)type reason:(NSString *)reason;
/**
 * @param groupId
 **/
- (void)groupWillGetGroupInfoWithGroupId:(NSString *)groupId;
/**
 * @param groupId 
 * @param Info
 **/
- (void)groupDidGetGroupInfoSuccessWithGroupId:(NSString *)groupId info:(NSDictionary *)info;
/**
 * @param type
 * @paramm reason
 **/
- (void)groupDidGetGroupInfoFailWithType:(int)type reason:(NSString *)reason;
/**
 * @param groupId
 **/
- (void)groupWillGetGroupDetailInfoWithGroupId:(NSString *)groupId;
/**
 * @param groupId
 * @param detailInfo
 **/
- (void)groupDidGetGroupDetailInfoSuccessWithGroupId:(NSString *)groupId detailInfo:(NSDictionary *)detailInfo;
/**
 * @param type
 * @paramm reason
 **/
- (void)groupDidGetGroupDetailInfoFailWithType:(int)type reason:(NSString *)reason;
/**
 * @param groupId
 * @param optId
 * @param deleteId
 **/
- (void)groupWillDeleteGroupMemberWithGroupId:(NSString *)groupId optId:(NSString *)optId
                                     deleteId:(NSString *)deleteId;
/**
 * @param groupId
 * @param optId
 * @param deleteId
 * @param result
 **/
- (void)groupDidDeleteGroupMemberSuccessWithGroupId:(NSString *)groupId optId:(NSString *)optId deleteId:(NSString *)deleteId result:(NSDictionary *)result;
/**
 * @param type
 * @paramm reason
 **/
- (void)groupDidDeleteGroupMemberFailWithType:(int)type reason:(NSString *)reason;
/**
 * @param optId
 * @param gid
 * @param ids
 * @param tag
 **/
- (void)groupWillAddMemberWithOptId:(NSString *)optId gid:(NSString *)gid ids:(NSArray *)ids;
/**
 * @param optId
 * @param gid
 * @param ids
 * @param tag
 **/
- (void)groupDidAddMemberSuccessWithOptId:(NSString *)optId gid:(NSString *)gid ids:(NSArray *)ids result:(NSDictionary *)result;
/**
 * @param type
 * @param reason
 * @param tag
 **/
- (void)groupDidAddMemberFailWithType:(int)type reason:(NSString *)reason;
/**
 * @param optId
 * @param gid
 * @param ids
 * @param tag
 **/
- (void)groupWillQueryWithGroupId:(NSString *)groupId;
/**
 * @param optId
 * @param gid
 * @param ids
 * @param tag
 **/
- (void)groupDidQuerySuccessWithGroupId:(NSString *)groupId result:(NSArray *)result;
/**
 * @param type
 * @param reason
 **/
- (void)groupDidQueryFailWithType:(int)type reason:(NSString *)reason;
/**
 * @param groupId
 * @param type
 * @param optId
 **/
- (void)groupWillQueryGroupMemberAccountOrUidWithGroupId:(NSString *)groupId type:(QueryMemberType)type optId:(NSString *)optId;
/**
 * @param groupId
 * @param type
 * @param optId
 * @param result
 **/
- (void)groupDidQueryGroupMemberAccountOrUidSuccessWithGroupId:(NSString *)groupId type:(QueryMemberType)type optId:(NSString *)optId result:(NSDictionary *)result;
/**
 * @param type
 * @param reason
 **/
- (void)groupDidQueryGroupMemberAccountOrUidFailWithType:(int)type reason:(NSString *)reason;
/**
 * @param groupId
 * @param groupInfo
 **/
- (void)groupWillSetGroupInfoWithGroupId:(NSString *)groupId groupInfo:(NSDictionary *)groupInfo;
/**
 * @param groupId
 * @param groupInfo
 * @param result
 **/
- (void)groupDidSetGroupInfoSuccessWithGroupId:(NSString *)groupId groupInfo:(NSDictionary *)groupInfo result:(NSDictionary *)result;
/**
 * @param type
 * @param reason
 **/
- (void)groupDidSetGroupInfoFailWithType:(int)type reason:(NSString *)reason;
/**
 * @param groupId
 * @param optId
 * @param settings
 **/
- (void)groupWillPersonalizedSettingsWithGroupId:(NSString *)groupId optId:(NSString *)optId settings:(NSDictionary *)settings;
/**
 * @param groupId
 * @param optId
 * @param settings
 * @param result
 **/
- (void)groupDidPersonalizedSettingsSuccessWithGroupId:(NSString *)groupId optId:(NSString *)optId settings:(NSDictionary *)settings result:(NSDictionary *)result;
/**
 * @param type
 * @param reason
 **/
- (void)groupDidPersonalizedSettingsFailWithType:(int)type reason:(NSString *)reason;
@end

@interface GroupHandle : NSObject
#pragma mark -
#pragma mark - attribute

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) id<groupDelegate> delegate;

#pragma mark -
#pragma mark - Initialized and Creating
/**
 * @param url
 * @param delegate
 **/
- (id)initWithUrl:(NSString *)url Delegate:(id<groupDelegate>)delegate;

#pragma mark -
#pragma mark - function

/**
 * @param optId
 * @param ids
 **/
- (void)createGroupWithOptId:(NSString *)optId ids:(NSArray *)ids;
/**
 * get user groups  info
 * @param optId
 **/
- (void)getUserGroupsInfoWithOptId:(NSString *)optId;
/**
 * get group info according to group id
 * @param groupId
 **/
- (void)getGroupInfoWithGroupId:(NSString *)groupId;
/**
 * get group info and members according group id
 * @param groupId
 **/
- (void)getGroupDetailInfoWithGroupId:(NSString *)groupId;
/**
 * delete group member
 * @param groupId
 * @param optId
 * @param deleteId
 **/
- (void)deleteGroupMemberWithGroupId:(NSString *)groupId optId:(NSString *)optId deleteId:(NSString *)deleteId;

/**
 * @param optId
 * @param gid
 * @param ids
 **/
- (void)addGroupMembersWithOptId:(NSString *)optId gid:(NSString *)gid ids:(NSArray *)ids;

/**
 * query group members according group id.
 * @param optId
 * @param gid
 **/
- (void)queryGroupMemberWithGroupId:(NSString *)groupId;

/**
 * query uid or account number of group member according group id.
 * @param groupId 
 * @param type
 * @param optId
 **/
- (void)queryGroupMemberAccountOrUidWithGroupId:(NSString *)groupId type:(QueryMemberType)type optId:(NSString *)optId;
/**
 * set group info
 * @param groupId
 * @param groupInfo :avatar、name、type_id、keyword、description、notice
 **/
- (void)setGroupInfoWithGroupId:(NSString *)groupId groupInfo:(NSDictionary *)groupInfo;
/**
 * group personalized Settings
 * @param groupId
 * @param optId
 * @param settings :nicename、is_msg_notity、is_save、is_top、is_show_member_nicename
 **/
- (void)groupPersonalizedSettingsWithGroupId:(NSString *)groupId optId:(NSString *)optId settings:(NSDictionary *)settings;

@end
