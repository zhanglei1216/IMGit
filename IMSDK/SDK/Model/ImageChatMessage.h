//
//  ImageChatMessage.h
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
@interface ImageChatMessage : ChatMessage

#pragma mark -
#pragma mark - attribute
@property (nonatomic, readonly) Byte TYPE_CODE;
@property (nonatomic, strong) NSString *mediaId;
@property (nonatomic, strong) NSData *thumbContent;


#pragma mark -
#pragma mark - Initialized and Creating
/**
 * @param Id
 * @param to
 * @param from
 * @param timestamp
 **/
- (id)initWithId:(NSString *)Id from:(NSString *)from to:(NSString *)to timestamp:(long)timestamp;
/**
 * @param Id
 **/
- (id)initWithId:(NSString *)Id;
@end
