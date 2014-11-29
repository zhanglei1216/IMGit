//
//  GroupHandle.m
//  IMSDK
//
//  Created by foreveross－bj on 14-11-21.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "GroupHandle.h"
#import "HttpRequest.h"
#import "Socket.h"

#define kGroupCreate @"/api/group/create"
#define kGroupAdd @"/api/group/add/"
#define kGroupDelete @"/api/group/exit/"
#define kUserGroupsInfo @"/api/group/listUserGroup/"
#define kGroupInfo @"/api/group/get/"
#define kGroupDetailInfo @"/api/group/getDetailGroup/"
#define kGroupQuery @"/api/group/listUser/"
#define kGroupQueryMember @"/api/group/listSimpleUser/"
#define kGroupSetGroupInfo @"/api/group/update/"
#define kGroupPersonalized @"/api/group/customize/"


@interface GroupHandle ()
{
    dispatch_queue_t groupWillOprationQueue;
   
}
@property (nonatomic, strong) NSDictionary *headerDic;

@end
@implementation GroupHandle

#pragma mark -
#pragma mark - Initialized and Creating
/**
 * @param url
 * @param delegate
 **/
- (id)initWithUrl:(NSString *)url Delegate:(id<groupDelegate>)delegate{
    self = [super init];
    if (self) {
        self.url = url;
        self.delegate = delegate;
        groupWillOprationQueue = dispatch_get_global_queue(0, 0);
        self.headerDic = @{@"Content-Type":@"application/json;charset=UTF-8", @"Accept-Charset":@"UTF-8"};
    }
    return self;
}
- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
    dispatch_release(groupWillOprationQueue);
#endif
}

#pragma mark -
#pragma mark - function

/**
 * @param optId
 * @param ids
 **/
- (void)createGroupWithOptId:(NSString *)optId ids:(NSArray *)ids{
    NSString *url = [NSString stringWithFormat:@"%@%@",self.url, kGroupCreate];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:optId forKey:@"accountUid"];
    NSMutableArray *members = [[NSMutableArray alloc] init];
    for (NSString *uid in ids) {
        NSDictionary *aDic = [NSDictionary dictionaryWithObject:uid forKey:@"accountUid"];
        [members addObject:aDic];
    }
    [dic setObject:members forKey:@"members"];
     NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
     NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (_delegate && [_delegate respondsToSelector:@selector(groupWillCreateWithOptId:ids:)]) {
        dispatch_async(groupWillOprationQueue, ^{@autoreleasepool{
            [_delegate groupWillCreateWithOptId:optId ids:ids];
            [self createGroupWithUrl:url json:json optId:optId ids:ids];
        }
        });
    }else{
        [self createGroupWithUrl:url json:json optId:optId ids:ids];
    }
}

- (void)createGroupWithUrl:(NSString *)url json:(NSString *)json optId:(NSString *)optId ids:(NSArray *)ids{
    HttpRequest *httpRequest = [[HttpRequest alloc] initWithUrl:url];
    [httpRequest setHttpMethod:@"POST"];
    [httpRequest setHttpBody:json];
    [httpRequest addHeadersWithDictionary:_headerDic];
    [httpRequest startRequtstWithSuccess:^(NSData *result) {
        NSDictionary *resultDic = nil;
        if (result) {
            NSError *error = nil;
            resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                DDLogError(@"%@", error);
            }else{
                if (resultDic[@"errcode"] != nil) {
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidCreateFailWithType:reason:)]) {
                        [_delegate groupDidCreateFailWithType:[resultDic[@"errcode"] intValue] reason:resultDic[@"errmsg"]];
                    }
                }else{
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidCreateSuccessOptId:ids:result:)]) {
                        [_delegate groupDidCreateSuccessOptId:optId ids:ids result:resultDic];
                    }
                }
                DDLogInfo(@"%@", resultDic);
            }
        }else{
            DDLogWarn(@"create group result is nil");
        }
        
        
    } fail:^(NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(groupDidCreateFailWithType:reason:)]) {
            [_delegate groupDidCreateFailWithType:(int)error.code reason:error.localizedDescription];
        }
        DDLogError(@"%@", error);
        
    }];
}
/**
 * @param optId
 * @param gid
 * @param ids
 **/
- (void)addGroupMembersWithOptId:(NSString *)optId gid:(NSString *)gid ids:(NSArray *)ids{
    NSString *url = [NSString stringWithFormat:@"%@%@%@-%@",self.url, kGroupAdd,gid,optId];
    NSData *data = [NSJSONSerialization dataWithJSONObject:ids options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (_delegate && [_delegate respondsToSelector:@selector(groupWillAddMemberWithOptId:gid:ids:)]) {
        dispatch_async(groupWillOprationQueue, ^{@autoreleasepool{
            [_delegate groupWillAddMemberWithOptId:optId gid:gid ids:ids];
            [self addGroupMembersWithUrl:url json:json optId:optId gid:gid ids:ids];
        }
        });
    }
}
- (void)addGroupMembersWithUrl:(NSString *)url json:(NSString *)json optId:(NSString *)optId gid:(NSString *)gid ids:(NSArray *)ids{
    HttpRequest *httpRequest = [[HttpRequest alloc] initWithUrl:url];
    [httpRequest setHttpBody:json];
    [httpRequest setHttpMethod:@"POST"];
    [httpRequest addHeadersWithDictionary:_headerDic];
    [httpRequest startRequtstWithSuccess:^(NSData *result) {
        NSDictionary *resultDic = nil;
        if (result) {
            NSError *error = nil;
            resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                DDLogError(@"%@", error);
            }else{
                if (resultDic[@"errcode"] != nil) {
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidAddMemberFailWithType:reason:)]) {
                        [_delegate groupDidAddMemberFailWithType:[resultDic[@"errcode"] intValue] reason:resultDic[@"errmsg"]];
                    }
                }else{
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidAddMemberSuccessWithOptId:gid:ids:result:)]) {
                        [_delegate groupDidAddMemberSuccessWithOptId:optId gid:gid ids:ids result:resultDic];
                    }
                }
                DDLogInfo(@"%@", resultDic);
            }
        }else{
            DDLogWarn(@"create group result is nil");
        }
    } fail:^(NSError *error) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(groupDidAddMemberFailWithType:reason:)]) {
            [_delegate groupDidAddMemberFailWithType:(int)error.code reason:error.localizedDescription];
        }
        DDLogError(@"%@", error);
    }];
}


/**
 * get user groups  info
 * @param optId
 **/
- (void)getUserGroupsInfoWithOptId:(NSString *)optId{
    NSString *url = [NSString stringWithFormat:@"%@%@%@", self.url, kUserGroupsInfo, optId];
    if (_delegate && [_delegate respondsToSelector:@selector(groupWillGetUserGroupsInfoWithOptId:)]) {
        dispatch_async(groupWillOprationQueue, ^{@autoreleasepool{
            [_delegate groupWillGetUserGroupsInfoWithOptId:optId];
            [self getUserGroupsInfoWithUrl:url OptId:optId];
        }
        });
    }else{
        [self getUserGroupsInfoWithUrl:url OptId:optId];
    }
}
- (void)getUserGroupsInfoWithUrl:(NSString *)url OptId:(NSString *)optId{
    HttpRequest *httpRequest = [[HttpRequest alloc] initWithUrl:url];
    [httpRequest setHttpMethod:@"GET"];
    [httpRequest addHeadersWithDictionary:_headerDic];
    [httpRequest startRequtstWithSuccess:^(NSData *result) {
        id resultDic = nil;
        if (result) {
            NSError *error = nil;
            resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                DDLogError(@"%@", error);
            }else{
                if ([resultDic isKindOfClass:[NSDictionary class]] && resultDic[@"errcode"] != nil) {
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidGetUserGroupsInfoFailWithType:reason:)]) {
                        [_delegate groupDidGetUserGroupsInfoFailWithType:[resultDic[@"errcode"] intValue] reason:resultDic[@"errmsg"]];
                    }
                }else{
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidGetUserGroupsSuccessWithOptId:Info:)]) {
                        [_delegate groupDidGetUserGroupsSuccessWithOptId:optId Info:resultDic];
                    }
                }
                DDLogInfo(@"%@", resultDic);
            }
        }else{
            DDLogWarn(@"create group result is nil");
        }
    } fail:^(NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(groupDidGetUserGroupsInfoFailWithType:reason:)]) {
            [_delegate groupDidGetUserGroupsInfoFailWithType:(int)error.code reason:error.localizedDescription];
        }
        DDLogError(@"%@", error);
    }];
}

/**
 * get group info according to group id
 * @param groupId
 **/
- (void)getGroupInfoWithGroupId:(NSString *)groupId{
    NSString *url = [NSString stringWithFormat:@"%@%@%@", self.url, kGroupInfo, groupId];
    if (_delegate && [_delegate respondsToSelector:@selector(groupWillGetGroupInfoWithGroupId:)]) {
        dispatch_async(groupWillOprationQueue, ^{@autoreleasepool{
            [_delegate groupWillGetGroupInfoWithGroupId:groupId];
            [self getGroupInfoWithUrl:url groupId:groupId];
        }
        });
    }else{
        [self getGroupInfoWithUrl:url groupId:groupId];
    }
}

- (void)getGroupInfoWithUrl:(NSString *)url groupId:(NSString *)groupId{
    HttpRequest *httpRequest = [[HttpRequest alloc] initWithUrl:url];
    [httpRequest setHttpMethod:@"GET"];
    [httpRequest addHeadersWithDictionary:_headerDic];
    [httpRequest startRequtstWithSuccess:^(NSData *result) {
        NSDictionary *resultDic = nil;
        if (result) {
            NSError *error = nil;
            resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                DDLogError(@"%@", error);
            }else{
                if (resultDic[@"errcode"] != nil) {
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidGetGroupInfoFailWithType:reason:)]) {
                        [_delegate groupDidGetGroupInfoFailWithType:[resultDic[@"errcode"] intValue] reason:resultDic[@"errmsg"]];
                    }
                }else{
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidGetGroupInfoSuccessWithGroupId:info:)]) {
                        [_delegate groupDidGetGroupInfoSuccessWithGroupId:groupId info:resultDic];
                    }
                }
                DDLogInfo(@"%@", resultDic);
            }
        }else{
            DDLogWarn(@"create group result is nil");
        }
    } fail:^(NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(groupDidGetGroupInfoFailWithType:reason:)]) {
            [_delegate groupDidGetGroupInfoFailWithType:(int)error.code reason:error.localizedDescription];
        }
        DDLogError(@"%@", error);
    }];
}
/**
 * get group info and members according group id
 * @param groupId
 **/
- (void)getGroupDetailInfoWithGroupId:(NSString *)groupId{
    NSString *url = [NSString stringWithFormat:@"%@%@%@", self.url, kGroupDetailInfo, groupId];
    if (_delegate && [_delegate respondsToSelector:@selector(groupWillGetGroupDetailInfoWithGroupId:)]) {
        dispatch_async(groupWillOprationQueue, ^{@autoreleasepool{
            [_delegate groupWillGetGroupDetailInfoWithGroupId:groupId];
            [self getGroupDetailInfoWithUrl:url groupId:groupId];
        }
        });
       
    }else{
        [self getGroupDetailInfoWithUrl:url groupId:groupId];
    }
}
- (void)getGroupDetailInfoWithUrl:(NSString *)url groupId:(NSString *)groupId{
    HttpRequest *httpRequest = [[HttpRequest alloc] initWithUrl:url];
    [httpRequest setHttpMethod:@"GET"];
    [httpRequest addHeadersWithDictionary:_headerDic];
    [httpRequest startRequtstWithSuccess:^(NSData *result) {
        NSDictionary *resultDic = nil;
        if (result) {
            NSError *error = nil;
            resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                DDLogError(@"%@", error);
            }else{
                if (resultDic[@"errcode"] != nil) {
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidGetGroupDetailInfoFailWithType:reason:)]) {
                        [_delegate groupDidGetGroupDetailInfoFailWithType:[resultDic[@"errcode"] intValue] reason:resultDic[@"errmsg"]];
                    }
                }else{
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidGetGroupDetailInfoSuccessWithGroupId:detailInfo:)]) {
                        [_delegate groupDidGetGroupDetailInfoSuccessWithGroupId:groupId detailInfo:resultDic];
                    }
                }
                DDLogInfo(@"%@", resultDic);
            }
        }else{
            DDLogWarn(@"create group result is nil");
        }
    } fail:^(NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(groupDidGetGroupDetailInfoFailWithType:reason:)]) {
            [_delegate groupDidGetGroupDetailInfoFailWithType:(int)error.code reason:error.localizedDescription];
        }
        DDLogError(@"%@", error);
    }];
}

/**
 * delete group member
 * @param groupId
 * @param optId
 * @param deleteId
 **/
- (void)deleteGroupMemberWithGroupId:(NSString *)groupId optId:(NSString *)optId deleteId:(NSString *)deleteId{
    NSString *url = [NSString stringWithFormat:@"%@%@%@-%@-%@", self.url, kGroupDelete, groupId, optId, deleteId];
    if (_delegate && [_delegate respondsToSelector:@selector(groupWillDeleteGroupMemberWithGroupId:optId:deleteId:)]) {
        dispatch_async(groupWillOprationQueue, ^{@autoreleasepool{
            [_delegate groupWillDeleteGroupMemberWithGroupId:groupId optId:optId deleteId:deleteId];
            [self deleteGroupMemberWithUrl:url groupId:groupId optId:optId deleteId:deleteId];
        }
        });
       
        
    }else{
        [self deleteGroupMemberWithUrl:url groupId:groupId optId:optId deleteId:deleteId];
    }
}
- (void)deleteGroupMemberWithUrl:(NSString *)url groupId:(NSString *)groupId optId:(NSString *)optId deleteId:(NSString *)deleteId{
    HttpRequest *httpRequest = [[HttpRequest alloc] initWithUrl:url];
    [httpRequest setHttpMethod:@"GET"];
    [httpRequest addHeadersWithDictionary:_headerDic];
    [httpRequest startRequtstWithSuccess:^(NSData *result) {
        NSDictionary *resultDic = nil;
        if (result) {
            NSError *error = nil;
            resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                DDLogError(@"%@", error);
            }else{
                if (resultDic[@"errcode"] != nil) {
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidDeleteGroupMemberFailWithType:reason:)]) {
                        [_delegate groupDidDeleteGroupMemberFailWithType:[resultDic[@"errcode"] intValue] reason:resultDic[@"errmsg"]];
                    }
                }else{
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidDeleteGroupMemberSuccessWithGroupId:optId:deleteId:result:)]) {
                        [_delegate groupDidDeleteGroupMemberSuccessWithGroupId:groupId optId:optId deleteId:deleteId result:resultDic];
                    }
                }
                DDLogInfo(@"%@", resultDic);
            }
        }else{
            DDLogWarn(@"create group result is nil");
        }
    } fail:^(NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(groupDidDeleteGroupMemberFailWithType:reason:)]) {
            [_delegate groupDidDeleteGroupMemberFailWithType:(int)error.code reason:error.localizedDescription];
        }
        DDLogError(@"%@", error);
    }];
}

/**
 * query group members according group id
 * @param optId
 * @param gid
 **/
- (void)queryGroupMemberWithGroupId:(NSString *)groupId{
    NSString *url = [NSString stringWithFormat:@"%@%@%@", self.url, kGroupQuery, groupId];
    if (_delegate && [_delegate respondsToSelector:@selector(groupWillQueryWithGroupId:)]) {
        dispatch_async(groupWillOprationQueue, ^{@autoreleasepool{
            [_delegate groupWillQueryWithGroupId:groupId];
            [self queryGroupMemberWithUrl:url groupId:groupId];
        }
        });
    }else{
        [self queryGroupMemberWithUrl:url groupId:groupId];
    }
}
- (void)queryGroupMemberWithUrl:(NSString *)url groupId:(NSString *)groupId{
    HttpRequest *httpRequest = [[HttpRequest alloc] initWithUrl:url];
    [httpRequest setHttpMethod:@"GET"];
    [httpRequest addHeadersWithDictionary:_headerDic];
    [httpRequest startRequtstWithSuccess:^(NSData *result) {
        id resultDic = nil;
        if (result) {
            NSError *error = nil;
            resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                DDLogError(@"%@", error);
            }else{
                if ([resultDic isKindOfClass:[NSDictionary class]] && resultDic[@"errcode"] != nil) {
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidQueryFailWithType:reason:)]) {
                        [_delegate groupDidQueryFailWithType:[resultDic[@"errcode"] intValue] reason:resultDic[@"errmsg"]];
                    }
                }else{
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidQuerySuccessWithGroupId:result:)]) {
                        [_delegate groupDidQuerySuccessWithGroupId:groupId result:resultDic];
                    }
                }
                DDLogInfo(@"%@", resultDic);
            }
        }else{
            DDLogWarn(@"create group result is nil");
        }
    } fail:^(NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(groupDidQueryFailWithType:reason:)]) {
            [_delegate groupDidQueryFailWithType:(int)error.code reason:error.localizedDescription];
        }
        DDLogError(@"%@", error);
    }];
}
/**
 * query uid or account number of group member according group id.
 * @param groupId
 * @param type
 * @param optId
 **/
- (void)queryGroupMemberAccountOrUidWithGroupId:(NSString *)groupId type:(QueryMemberType)type optId:(NSString *)optId{
    NSString *url = nil;
    if (type == GroupQueryMemberAccount) {
        url = [NSString stringWithFormat:@"%@%@%@-USER-%@", self.url, kGroupQueryMember, groupId, optId];
    }else if(type == GroupQueryMemberUid){
        url = [NSString stringWithFormat:@"%@%@%@-UUID-%@", self.url, kGroupQueryMember, groupId, optId];
    }
    NSLog(@"%@", url);
    if (_delegate && [_delegate respondsToSelector:@selector(groupWillQueryGroupMemberAccountOrUidWithGroupId:type:optId:)]) {
        dispatch_async(groupWillOprationQueue, ^{@autoreleasepool{
            [_delegate groupWillQueryGroupMemberAccountOrUidWithGroupId:groupId type:type optId:optId];
            [self queryGroupMemberAccountOrUidWithUrl:url groupId:groupId type:type optId:optId];
        }
        });
    }else{
        [self queryGroupMemberAccountOrUidWithUrl:url groupId:groupId type:type optId:optId];
    }
}
- (void)queryGroupMemberAccountOrUidWithUrl:(NSString *)url groupId:(NSString *)groupId type:(int)type optId:(NSString *)optId{
    HttpRequest *httpRequest = [[HttpRequest alloc] initWithUrl:url];
    [httpRequest setHttpMethod:@"GET"];
    [httpRequest addHeadersWithDictionary:_headerDic];
    [httpRequest startRequtstWithSuccess:^(NSData *result) {
        NSDictionary *resultDic = nil;
        if (result) {
            NSError *error = nil;
            resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                DDLogError(@"%@", error);
            }else{
                if (resultDic[@"errcode"] != nil) {
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidQueryGroupMemberAccountOrUidFailWithType:reason:)]) {
                        [_delegate groupDidQueryGroupMemberAccountOrUidFailWithType:[resultDic[@"errcode"] intValue] reason:resultDic[@"errmsg"]];
                    }
                }else{
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidQueryGroupMemberAccountOrUidSuccessWithGroupId:type:optId:result:)]) {
                        [_delegate groupDidQueryGroupMemberAccountOrUidSuccessWithGroupId:groupId type:type optId:optId result:resultDic];
                    }
                }
                DDLogInfo(@"%@", resultDic);
            }
        }else{
            DDLogWarn(@"create group result is nil");
        }
    } fail:^(NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(groupDidQueryGroupMemberAccountOrUidFailWithType:reason:)]) {
            [_delegate groupDidQueryGroupMemberAccountOrUidFailWithType:(int)error.code reason:error.localizedDescription];
        }
        DDLogError(@"%@", error);
    }];
}
/**
 * set group info
 * @param groupId
 * @param groupInfo :avatar、name、type_id、keyword、description、notice
 **/
- (void)setGroupInfoWithGroupId:(NSString *)groupId groupInfo:(NSDictionary *)groupInfo{
    NSString *url = [NSString stringWithFormat:@"%@%@", self.url, kGroupSetGroupInfo];
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];
    [jsonDic setObject:groupId forKey:@"uid"];
    [jsonDic setValuesForKeysWithDictionary:groupInfo];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (_delegate && [_delegate respondsToSelector:@selector(groupWillSetGroupInfoWithGroupId:groupInfo:)]) {
        dispatch_async(groupWillOprationQueue, ^{@autoreleasepool{
            [_delegate groupWillSetGroupInfoWithGroupId:groupId groupInfo:groupInfo];
            [self setGroupInfoWithUrl:url groupId:groupId groupInfo:groupInfo json:json];
        }
        });
        
    }else{
        [self setGroupInfoWithUrl:url groupId:groupId groupInfo:groupInfo json:json];
    }
}
- (void)setGroupInfoWithUrl:(NSString *)url groupId:(NSString *)groupId groupInfo:(NSDictionary *)groupInfo json:(NSString *)json{
    HttpRequest *httpRequest = [[HttpRequest alloc] initWithUrl:url];
    [httpRequest setHttpMethod:@"POST"];
    [httpRequest setHttpBody:json];
    [httpRequest addHeadersWithDictionary:_headerDic];
    [httpRequest startRequtstWithSuccess:^(NSData *result) {
        NSDictionary *resultDic = nil;
        if (result) {
            NSError *error = nil;
            resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                DDLogError(@"%@", error);
            }else{
                if (resultDic[@"errcode"] != nil) {
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidSetGroupInfoFailWithType:reason:)]) {
                        [_delegate groupDidSetGroupInfoFailWithType:[resultDic[@"errcode"] intValue] reason:resultDic[@"errmsg"]];
                    }
                }else{
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidSetGroupInfoSuccessWithGroupId:groupInfo:result:)]) {
                        [_delegate groupDidSetGroupInfoSuccessWithGroupId:groupId groupInfo:groupInfo result:resultDic];
                    }
                }
                DDLogInfo(@"%@", resultDic);
            }
        }else{
            DDLogWarn(@"create group result is nil");
        }
        
    } fail:^(NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(groupDidSetGroupInfoFailWithType:reason:)]) {
            [_delegate groupDidSetGroupInfoFailWithType:(int)error.code reason:error.localizedDescription];
        }
        DDLogError(@"%@", error);
        
    }];
}
/**
 * group personalized Settings
 * @param groupId
 * @param optId
 * @param settings :nicename、is_msg_notity、is_save、is_top、is_show_member_nicename
 **/
- (void)groupPersonalizedSettingsWithGroupId:(NSString *)groupId optId:(NSString *)optId settings:(NSDictionary *)settings{
    NSString *url = [NSString stringWithFormat:@"%@%@", self.url, kGroupPersonalized];
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];
    [jsonDic setObject:groupId forKey:@"groupUid"];
    [jsonDic setObject:optId forKey:@"accountUid"];
    [jsonDic setValuesForKeysWithDictionary:settings];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (_delegate && [_delegate respondsToSelector:@selector(groupWillPersonalizedSettingsWithGroupId:optId:settings:)]) {
        dispatch_async(groupWillOprationQueue, ^{@autoreleasepool{
            [_delegate groupWillPersonalizedSettingsWithGroupId:groupId optId:optId settings:settings];
            [self groupPersonalizedSettingsWithUrl:url groupId:groupId optId:optId settings:settings json:json];
        }
        });
        
    }else{
       [self groupPersonalizedSettingsWithUrl:url groupId:groupId optId:optId settings:settings json:json];
    }
}
- (void)groupPersonalizedSettingsWithUrl:(NSString *)url groupId:(NSString *)groupId optId:(NSString *)optId settings:(NSDictionary *)settings json:(NSString *)json{
    HttpRequest *httpRequest = [[HttpRequest alloc] initWithUrl:url];
    [httpRequest setHttpMethod:@"POST"];
    [httpRequest setHttpBody:json];
    [httpRequest addHeadersWithDictionary:_headerDic];
    [httpRequest startRequtstWithSuccess:^(NSData *result) {
        NSDictionary *resultDic = nil;
        if (result) {
            NSError *error = nil;
            resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                DDLogError(@"%@", error);
            }else{
                if (resultDic[@"errcode"] != nil) {
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidPersonalizedSettingsFailWithType:reason:)]) {
                        [_delegate groupDidPersonalizedSettingsFailWithType:[resultDic[@"errcode"] intValue] reason:resultDic[@"errmsg"]];
                    }
                }else{
                    if (_delegate && [_delegate respondsToSelector:@selector(groupDidPersonalizedSettingsSuccessWithGroupId:optId:settings:result:)]) {
                        [_delegate groupDidPersonalizedSettingsSuccessWithGroupId:groupId optId:optId settings:settings result:resultDic];
                    }
                }
                DDLogInfo(@"%@", resultDic);
            }
        }else{
            DDLogWarn(@"create group result is nil");
        }
        
    } fail:^(NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(groupDidPersonalizedSettingsFailWithType:reason:)]) {
            [_delegate groupDidPersonalizedSettingsFailWithType:(int)error.code reason:error.localizedDescription];
        }
        DDLogError(@"%@", error);
        
    }];
}
@end
