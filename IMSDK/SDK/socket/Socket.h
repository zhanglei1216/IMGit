//
//  Socket.h
//  IMSDK
//
//  Created by foreveross－bj on 14-10-29.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//
#import "DDLog.h"
#import "DDTTYLogger.h"

#define kHeaderLength 5

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

enum SocketErrorCode{
    SocketClientFailConnect = 20,
    SocketClientLostConnect,
    SocketClientConnectOtherError,
    socketAuthorizeFailError = 30,
    socketAuthorizeOthorError,
    SocketSendMessageNilError = 50,
    SocketSendMessageTypeError,
    
};
enum SocketHandleMessageType{
    SocketSendMessage = 0,
    SocketReadHeader,
    SocketReadBody
};
typedef enum SocketHandleMessageType HandleMessageType;

enum SocketSendMessageType{
    ChatType = 1,
    HeartBeatType,
    RequestType,
    ResponseType,
    CommandType
};
typedef enum SocketSendMessageType SendMessageType;

enum SocketResponseCode{
    SocketMessageSendSuccessResponse = 101,
    SocketMessageSendFailRespones = 102,
    SocketHeartbeatResponse = 110,
    SocketNoAuthorizeConnectResponse = 141,
    SocketNoLoginRespone,
    SocketUnknownErrorRespone,
    SocketMessageFormatErrorRespone,
    SocketChangeRespone = 301,
    SocketRequestQuitRespone = 310,
    SocketAuthorizeSuccessRespone = 3101,
    SocketAuthorizeFailRespone,
};
typedef enum SocketResponseCode ResonseCode;