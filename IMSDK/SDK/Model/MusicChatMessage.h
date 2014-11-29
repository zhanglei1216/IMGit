//
//  MusicChatMessage.h
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
@interface MusicChatMessage : ChatMessage
{
    NSString *_description;
}
#pragma mark -
#pragma mark - attribute
@property (nonatomic, readonly) Byte TYPE_CODE;
@property (nonatomic, strong) NSString *mediaId;
@property (nonatomic, strong) NSString *musicUrl;
@property (nonatomic, strong) NSString *hqMusicUrl;
@property (nonatomic, strong) NSString *thumbId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, assign) int playTime;

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
