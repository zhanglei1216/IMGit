//
//  GroupViewController.m
//  IMSDK
//
//  Created by foreveross－bj on 14-11-27.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "GroupViewController.h"
#import "Socket.h"

@interface GroupViewController ()
{
    GroupHandle *groupHandle;
}
@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    groupHandle = [[GroupHandle alloc] initWithUrl:@"http://192.168.0.99:8080" Delegate:self];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 120, 60);
    [button setTitle:@"create group" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)create{
//    [groupHandle createGroupWithOptId:@"cenzhongyuan" ids:@[@"lujun"]];
//    [groupHandle addGroupMembersWithOptId:@"cenzhongyuan" gid:@"C8FD7B1ED2224E588F0EA7450DA2C1B1" ids:@[@"donghu"]];
//    [groupHandle getUserGroupsInfoWithOptId:@"lujun"];
//    [groupHandle getGroupInfoWithGroupId:@"C8FD7B1ED2224E588F0EA7450DA2C1B1"];
//    [groupHandle getGroupDetailInfoWithGroupId:@"C8FD7B1ED2224E588F0EA7450DA2C1B1"];
//    [groupHandle deleteGroupMemberWithGroupId:@"C8FD7B1ED2224E588F0EA7450DA2C1B1" optId:@"cenzhongyuan" deleteId:@"donghu"];
//    [groupHandle queryGroupMemberWithGroupId:@"C8FD7B1ED2224E588F0EA7450DA2C1B1"];
//    [groupHandle queryGroupMemberAccountOrUidWithGroupId:@"C8FD7B1ED2224E588F0EA7450DA2C1B1" type:GroupQueryMemberUid optId:@"lujun"];
    //avatar、name、type_id、keyword、description、notice
//    NSDictionary *dic = @{@"name":@"测试群"};
//    [groupHandle setGroupInfoWithGroupId:@"C8FD7B1ED2224E588F0EA7450DA2C1B1" groupInfo:dic];
    //nicename、is_msg_notity、is_save、is_top、is_show_member_nicename
    NSDictionary *dic = @{@"nicename":@"蓝色贝壳"};
    [groupHandle groupPersonalizedSettingsWithGroupId:@"C8FD7B1ED2224E588F0EA7450DA2C1B1" optId:@"zhanglei" settings:dic];
    
    
}
- (void)groupWillCreateWithOptId:(NSString *)optId ids:(NSArray *)ids{
    DDLogInfo(@"%s %@", __FUNCTION__, optId);
}

- (void)groupDidCreateSuccessOptId:(NSString *)optId ids:(NSArray *)ids result:(NSString *)result{
    DDLogInfo(@"%s %@",__FUNCTION__, result);
}
- (void)groupDidCreateFailWithType:(int)type reason:(NSString *)reason{
    DDLogInfo(@"%s %d, %@",__FUNCTION__, type, reason);
}
- (void)groupWillAddMemberWithOptId:(NSString *)optId gid:(NSString *)gid ids:(NSArray *)ids{
    DDLogInfo(@"%s %@", __FUNCTION__, optId);
}
- (void)groupDidAddMemberSuccessWithOptId:(NSString *)optId gid:(NSString *)gid ids:(NSArray *)ids result:(NSDictionary *)result{
    DDLogInfo(@"%s %@",__FUNCTION__, result);
}
- (void)groupDidAddMemberFailWithType:(int)type reason:(NSString *)reason{
    DDLogInfo(@"%s %d, %@",__FUNCTION__, type, reason);
}
- (void)groupWillGetUserGroupsInfoWithOptId:(NSString *)optId{
    DDLogInfo(@"%s %@", __FUNCTION__, optId);
}
- (void)groupDidGetUserGroupsSuccessWithOptId:(NSString *)optId Info:(NSDictionary *)info{
    DDLogInfo(@"%s %@",__FUNCTION__, info);
}
- (void)groupDidGetUserGroupsInfoFailWithType:(int)type reason:(NSString *)reason{
    DDLogInfo(@"%s %d, %@",__FUNCTION__, type, reason);
}
- (void)groupWillGetGroupInfoWithGroupId:(NSString *)groupId{
    DDLogInfo(@"%s %@", __FUNCTION__, groupId);
}
- (void)groupDidGetGroupInfoSuccessWithGroupId:(NSString *)groupId info:(NSDictionary *)info{
    DDLogInfo(@"%s %@",__FUNCTION__, info);
}
- (void)groupDidGetGroupInfoFailWithType:(int)type reason:(NSString *)reason{
    DDLogInfo(@"%s %d, %@",__FUNCTION__, type, reason);
}
- (void)groupWillGetGroupDetailInfoWithGroupId:(NSString *)groupId{
    DDLogInfo(@"%s %@", __FUNCTION__, groupId);
}
- (void)groupDidGetGroupDetailInfoSuccessWithGroupId:(NSString *)groupId detailInfo:(NSDictionary *)detailInfo{
    DDLogInfo(@"%s %@",__FUNCTION__, detailInfo);
}
- (void)groupDidGetGroupDetailInfoFailWithType:(int)type reason:(NSString *)reason{
    DDLogInfo(@"%s %d, %@",__FUNCTION__, type, reason);
}
- (void)groupWillDeleteGroupMemberWithGroupId:(NSString *)groupId optId:(NSString *)optId deleteId:(NSString *)deleteId{
    DDLogInfo(@"%s %@", __FUNCTION__, deleteId);
}
- (void)groupDidDeleteGroupMemberSuccessWithGroupId:(NSString *)groupId optId:(NSString *)optId deleteId:(NSString *)deleteId result:(NSDictionary *)result{
    DDLogInfo(@"%s %@",__FUNCTION__, result);
}
- (void)groupDidDeleteGroupMemberFailWithType:(int)type reason:(NSString *)reason{
    DDLogInfo(@"%s %d, %@",__FUNCTION__, type, reason);
}
- (void)groupWillQueryWithGroupId:(NSString *)groupId{
    DDLogInfo(@"%s %@", __FUNCTION__, groupId);
}
- (void)groupDidQuerySuccessWithGroupId:(NSString *)groupId result:(NSDictionary *)result{
    DDLogInfo(@"%s %@",__FUNCTION__, result);
}
- (void)groupDidQueryFailWithType:(int)type reason:(NSString *)reason{
    DDLogInfo(@"%s %d, %@",__FUNCTION__, type, reason);
}
- (void)groupWillQueryGroupMemberAccountOrUidWithGroupId:(NSString *)groupId type:(QueryMemberType)type optId:(NSString *)optId{
    DDLogInfo(@"%s %@", __FUNCTION__, groupId);
}
- (void)groupDidQueryGroupMemberAccountOrUidSuccessWithGroupId:(NSString *)groupId type:(QueryMemberType)type optId:(NSString *)optId result:(NSDictionary *)result{
    DDLogInfo(@"%s %@",__FUNCTION__, result);
}
- (void)groupDidQueryGroupMemberAccountOrUidFailWithType:(int)type reason:(NSString *)reason{
    DDLogInfo(@"%s %d, %@",__FUNCTION__, type, reason);
}
- (void)groupWillSetGroupInfoWithGroupId:(NSString *)groupId groupInfo:(NSDictionary *)groupInfo{
    DDLogInfo(@"%s %@", __FUNCTION__, groupId);
}
- (void)groupDidSetGroupInfoSuccessWithGroupId:(NSString *)groupId groupInfo:(NSDictionary *)groupInfo result:(NSDictionary *)result{
    DDLogInfo(@"%s %@",__FUNCTION__, result);
}
- (void)groupDidSetGroupInfoFailWithType:(int)type reason:(NSString *)reason{
    DDLogInfo(@"%s %d, %@",__FUNCTION__, type, reason);
}
- (void)groupWillPersonalizedSettingsWithGroupId:(NSString *)groupId optId:(NSString *)optId settings:(NSDictionary *)settings{
    DDLogInfo(@"%s %@", __FUNCTION__, groupId);
}
- (void)groupDidPersonalizedSettingsFailWithType:(int)type reason:(NSString *)reason{
    DDLogInfo(@"%s %d, %@",__FUNCTION__, type, reason);
}
- (void)groupDidPersonalizedSettingsSuccessWithGroupId:(NSString *)groupId optId:(NSString *)optId settings:(NSDictionary *)settings result:(NSDictionary *)result{
    DDLogInfo(@"%s %@",__FUNCTION__, result);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
