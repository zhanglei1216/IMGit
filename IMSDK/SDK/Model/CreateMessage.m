//
//  CreateMessage.m
//  IMSDK
//
//  Created by foreveross－bj on 14-11-4.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "CreateMessage.h"

@implementation CreateMessage
+ (Message *)messageWithData:(NSData *)data type:(SendMessageType)type error:(NSError **)error{
    if (data) {
        id result = [MPMessagePackReader readData:data error:error];
        if (!*error) {
            if ([result isKindOfClass:[NSDictionary class]]) {
                 Message *message = nil;
                if (type == ResponseType) {
                    message = [[ResponseMessage alloc] init];
                }
                if (type == ChatType) {
                    switch ([result[@"msgType"] integerValue]) {
                        case TextChatMessageType:{
                            message = [[TextChatMessage alloc] init];
                        }
                            break;
                        case ImageChatMessageType:{
                            message = [[ImageChatMessage alloc] init];
                        }
                            break;
                        case VoiceChatMessageType:{
                            message = [[VoiceChatMessage alloc] init];
                        }
                            break;
                        case VideoChatMessageType:{
                            message = [[VideoChatMessage alloc] init];
                        }
                            break;
                        case MusicChatMessageType:{
                            message = [[MusicChatMessage alloc] init];
                        }
                            break;
                        case NewsChatMessageType:{
                            message = [[NewsChatMessage alloc] init];
                        }
                            break;
                        case MenuEventChatMessageType:{
                            message = [[MenuEventChatMessage alloc] init];
                        }
                            break;
                    }
                }
                if (type == HeartBeatType) {
                    message = [[HeartBeatMessage alloc] init];
                }
               
                if (message != nil) {
                    [message setValuesForKeysWithDictionary:result];
                }
                return message;
            }else{
                *error = [NSError errorWithDomain:@"paraser result is not dictionary" code:0 userInfo:nil];
                return nil;
            }
        }else{
            *error = [NSError errorWithDomain:@"message data is error" code:0 userInfo:nil];
            return nil;
        }
        
    }else{
        *error = [NSError errorWithDomain:@"message data is nil" code:0 userInfo:nil];
        return nil;
    }
    
}
@end
