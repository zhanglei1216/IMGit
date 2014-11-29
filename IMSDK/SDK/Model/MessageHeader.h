//
//  MessageHearder.h
//  IMSDK
//
//  Created by foreveross－bj on 14-11-4.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "Message.h"
#import "ChatMessage.h"
#import "CommandMessage.h"
#import "HeartBeatMessage.h"
#import "ResponseMessage.h"
#import "ResponseMessage.h"
#import "GroupUserAddCmdMessage.h"
#import "GroupUserDelCmdMessage.h"
#import "ImageChatMessage.h"
#import "MusicChatMessage.h"
#import "VideoChatMessage.h"
#import "VoiceChatMessage.h"
#import "TextChatMessage.h"
#import "NewsChatMessage.h"
#import "MenuEventChatMessage.h"
#import "QuitCommandMessage.h"
#import "ReceiptCmdMessage.h"
#import "TokenRequestMessage.h"

enum MessageType{
    TextChatMessageType = 11,
    ImageChatMessageType,
    VoiceChatMessageType,
    VideoChatMessageType,
    MusicChatMessageType,
    NewsChatMessageType,
    MenuEventChatMessageType,
    HeartBeatMessageType = 21,
    TokenRequestMessageType = 31,
    ResponseMessageType = 41,
    QuitCommandMessageType = 51,
    GroupUserAddCmdMessageType,
    GroupUserDelCmdMessageType,
    ReceiptCmdMessageType
};

