//
//  ConnectSocket.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-29.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "ConnectSocket.h"
#import "Reachability.h"
#import "Socket.h"


#define MIN_KEEPALIVE_INTERVAL (4 * 60)
#define SEND_MESSAGE_TIMEOUT 20
#define CONNECT_TIMEOUT 20

@interface ConnectSocket ()
{
    GCDAsyncSocket *_socket;
    void *socketQueueTag;
    dispatch_queue_t timerQueue;
    dispatch_queue_t socketQueue;
    dispatch_queue_t willSendMessageQueue;
    dispatch_queue_t willAuthorizeQueue;
    dispatch_source_t timerSource;
    NSMutableDictionary *_writeMessageQueue;
    NSMutableData *_readData;
    NSString *_token;
    int32_t _DataLength;
    Parser *_paser;
    SendMessageType _sendMessageType;
    int _port;
    NSTimeInterval keepAliveInterval;
    Reachability *_reachability;
    BOOL isAuthorized;
    BOOL isAuthorizing;
}


#pragma mark -
#pragma mark - attribute
@property (nonatomic, strong) NSMutableDictionary *writeMessageQueue;
@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSMutableData *readData;
@property (nonatomic, strong) Parser *parser;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) Reachability *reachability;
@end

@implementation ConnectSocket

#pragma mark -
#pragma mark - Initialized and Creating
/**
 * @param delegate
 **/
- (id)initWithDelegate:(id<SocketDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self commonInit];
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:socketQueue];
        self.parser = [[Parser alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("parserDelegate", NULL)];
    }
    return self;
}
/**
 *  initialization between the various init methods.
 **/
- (void)commonInit{
    socketQueueTag = &socketQueueTag;
    socketQueue = dispatch_queue_create("socket", NULL);
    timerQueue = dispatch_queue_create("timeQueue", NULL);
    dispatch_queue_set_specific(socketQueue, socketQueueTag, socketQueueTag, NULL);
    willSendMessageQueue = dispatch_queue_create("willSendMessage", NULL);
    willAuthorizeQueue = dispatch_queue_create("willSendAuthorize", NULL);
    self.writeMessageQueue = [[NSMutableDictionary alloc] init];
    self.readData = [[NSMutableData alloc] init];
    [self netNotifition];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    keepAliveInterval = MIN_KEEPALIVE_INTERVAL;
    isAuthorized = NO;
    isAuthorizing = NO;
}
/**
 * Standard deallocation method.
 * Every object variable declared in the header file should be released here.
 **/
- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
    dispatch_release(socketQueue);
    dispatch_release(timerQueue);
    dispatch_release(willSendMessageQueue);
    dispatch_release(willAuthorizeQueue);
#endif
    
    [_socket setDelegate:nil delegateQueue:NULL];
    [_parser setDelegate:nil delegateQueue:NULL];
    [self disconnect];
    dispatch_source_cancel(timerSource);
    
}
#pragma mark -
#pragma mark - Function

/**
 * start network notifier
 **/
- (void)netNotifition{
    self.reachability = [Reachability reachabilityWithHostname:@"www.apple.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [_reachability startNotifier];
}
/**
 * if the network is changed, handel the socket.
 * if the network is not connected, the socket is disconnected.
 * if the network is connected, the socke is reconnected;
 **/
- (void)reachabilityChanged:(NSNotification *)note{
    Reachability * reachability = [note object];
    dispatch_block_t block = ^{@autoreleasepool{
        if(![reachability isReachable])
        {
            [self disconnect];
            
            if(timerSource){
                dispatch_source_cancel(timerSource);
                timerSource = NULL;
            }
        }else{
            if (_host) {
                [self reconnect];
            }
            
        }
        
    }
    };
    if (dispatch_get_specific(socketQueueTag)) {
        block();
    }else{
        dispatch_async(socketQueue, block);
    }
}
/**
 * @param ip
 * @param port
 **/
- (void)connectWithIp:(NSString *)ip port:(int)port{
    dispatch_block_t block = ^{@autoreleasepool{
        self.host = ip;
        _port = port;
        if (![_socket isConnected]) {
            [_socket setAutoDisconnectOnClosedReadStream:NO];
            NSError *error = nil;
            if (_delegate && [_delegate respondsToSelector:@selector(connectWillBegin)]) {
                [_delegate connectWillBegin];
            }
            BOOL isConnect = [_socket connectToHost:ip onPort:port withTimeout:CONNECT_TIMEOUT error:&error];
            if (!isConnect) {
                if (_delegate && [_delegate respondsToSelector:@selector(connectDidFailWithType:reason:)]) {
                    [_delegate connectDidFailWithType:SocketClientFailConnect reason:error.localizedDescription];
                }
            }
        }
    }
    };
    if (dispatch_get_specific(socketQueueTag)) {
        block();
    }else {
        dispatch_sync(socketQueue, block);
    }
    
}
/**
 * disConnect
 **/
- (void)disconnect{
    dispatch_block_t block = ^{@autoreleasepool{
        if ([_socket isConnected]) {
            if (_delegate && [_delegate respondsToSelector:@selector(connectWillAbort)]) {
                [_delegate connectWillAbort];
            }
            [_socket disconnect];
        }
    }
    };
    if (dispatch_get_specific(socketQueueTag)) {
        block();
    }else{
        dispatch_sync(socketQueue, block);
    }
}
/**
 * @return BOOL
 **/
- (BOOL)isConnected{
    __block BOOL result = false;
    dispatch_block_t block = ^{@autoreleasepool{
        result =[_socket isConnected];
    }
    };
    if (dispatch_get_specific(socketQueueTag)) {
        block();
    }else{
        dispatch_sync(socketQueue, block);
    }
    return result;
}
/**
 * Reconnect
 **/
- (void)reconnect{
    dispatch_block_t block = ^{@autoreleasepool{
        [self disconnect];
        [self connectWithIp:_host port:_port];
    }
    };
    if (dispatch_get_specific(socketQueueTag)) {
        block();
    }else{
        dispatch_sync(socketQueue, block);
    }
}

/**
 * send message
 **/
- (void)sendMessage:(Message *)message{
    if (_delegate && [_delegate respondsToSelector:@selector(messageWillSend:)]) {
        dispatch_async(willSendMessageQueue, ^{@autoreleasepool{
            [_delegate messageWillSend:message];
            dispatch_async(socketQueue, ^{@autoreleasepool{
                [self sendMessage:message timeout:SEND_MESSAGE_TIMEOUT type:ChatType];
            }
            });
        }
        });
    }else {
        dispatch_async(socketQueue, ^{@autoreleasepool{
                [self sendMessage:message timeout:SEND_MESSAGE_TIMEOUT type:ChatType];
        }
        });
    }
}
/**
 * @param message
 **/
- (void)authorizeWithMessage:(Message *)message{
    if ([_delegate respondsToSelector:@selector(authorizeWillBegin)]) {
        dispatch_async(willAuthorizeQueue, ^{@autoreleasepool{
            [_delegate authorizeWillBegin];
            dispatch_async(socketQueue, ^{@autoreleasepool{
                isAuthorizing = YES;
                self.token = ((TokenRequestMessage *) message).token;
                [self sendMessage:message timeout:SEND_MESSAGE_TIMEOUT type:RequestType];
            }
            });
            
        }
        });
    }else {
        dispatch_async(socketQueue, ^{@autoreleasepool{
            isAuthorizing = YES;
            self.token = ((TokenRequestMessage *) message).token;
            [self sendMessage:message timeout:SEND_MESSAGE_TIMEOUT type:ChatType];
        }
        });
    }
}
#pragma mark -
#pragma mark - GCDAsyncSocket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    if (_delegate && [_delegate respondsToSelector:@selector(connectDidSuccess)]) {
        [_delegate connectDidSuccess];
    }
    [_socket readDataToLength:kHeaderLength withTimeout:-1 tag:SocketReadHeader];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (err.code == GCDAsyncSocketConnectTimeoutError) {
        if (_delegate && [_delegate respondsToSelector:@selector(connectDidTimeout)]) {
            [_delegate connectDidTimeout];
        }
    }else if(err.code == GCDAsyncSocketDisconnectError){
        if (_delegate && [_delegate respondsToSelector:@selector(connectDidAbort)]) {
            [_delegate connectDidAbort];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(connectDidFailWithType:reason:)]) {
            [_delegate connectDidFailWithType:SocketClientConnectOtherError reason:err.localizedDescription];
        }
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    [_parser paraseData:data type:(HandleMessageType)tag];
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock{
    
}

#pragma mark -
#pragma mark - parser delegate
- (void)readToLength:(NSUInteger)length tag:(long)tag{
    [_socket readDataToLength:length withTimeout:-1 tag:tag];
}

- (void)readMessageWithMessage:(NSMutableArray *)messageQueue
{
    Message *message = [messageQueue firstObject];
    if (message) {
        if ([message isKindOfClass:[ResponseMessage class]]) {
            ResponseMessage *responseMessage = (ResponseMessage *)message;
            if ([_writeMessageQueue objectForKey:responseMessage.Id] != nil) {
                if(responseMessage.code == SocketAuthorizeSuccessRespone){
                    if (_delegate && [_delegate respondsToSelector:@selector(authorizeDidSuccess)]) {
                        [_delegate authorizeDidSuccess];
                    }
                    if (!timerSource) {
                        [self setupKeepAliveTimer];
                    }
                    isAuthorizing = NO;
                    isAuthorized = YES;
                    
                }else if (responseMessage.code == SocketAuthorizeFailRespone){
                    if (_delegate && [_delegate respondsToSelector:@selector(authorizeDidFailWithType:reason:)]) {
                        [_delegate authorizeDidFailWithType:responseMessage.code reason:responseMessage.message];
                    }
                    isAuthorized = NO;
                }else if (responseMessage.code == SocketMessageSendSuccessResponse){
                    if (_delegate && [_delegate respondsToSelector:@selector(messageDidSendSuccess:)]) {
                        [_delegate messageDidSendSuccess:[_writeMessageQueue objectForKey:responseMessage.Id]];
                    }
                }else if(responseMessage.code == SocketMessageSendFailRespones){
                    if (_delegate && [_delegate respondsToSelector:@selector(messageDidSendFail:)]){
                        [_delegate messageDidSendFail:[_writeMessageQueue objectForKey:responseMessage.Id]];
                    }
                }else if (responseMessage.code == SocketHeartbeatResponse){
                    DDLogInfo(@"socket connection is normal.");
                } else if(responseMessage.code == SocketMessageFormatErrorRespone){
                    DDLogWarn(@"the message format error");
                }
                [_writeMessageQueue removeObjectForKey:responseMessage.Id];
            }else{
                if (responseMessage.code == SocketNoAuthorizeConnectResponse) {
                    if (_token && isAuthorizing == NO) {
                        TokenRequestMessage *tokenMessage = [[TokenRequestMessage alloc] initWithId:[[NSUUID UUID] UUIDString] token:_token];
                        [self authorizeWithMessage:tokenMessage];
                    }
                    isAuthorized = NO;
                    DDLogWarn(@"no authorize connect");
                }else if(responseMessage.code == SocketNoLoginRespone){
                    DDLogWarn(@"no register");
                }
            }
        }else if([message isKindOfClass:[ChatMessage class]]){
            if (_delegate && [_delegate respondsToSelector:@selector(messageDidReceived:)]) {
                [_delegate messageDidReceived:message];
            }
        }
    }
    [messageQueue removeObjectAtIndex:0];
}

#pragma mark -
#pragma mark - private function
/**
 * @param message
 * @return data
 * transform message to data.
 **/
- (NSData *)dataWithMessage:(Message *)message{
    __block NSMutableData *fullData = nil;
    dispatch_block_t block = ^{@autoreleasepool{
        NSData *enMessageData = [Tools encryptionWithMessage:message.data key:message.data.length % 8 methon:ENCRYPT];
        Byte type = [self sendMessageType:message];
        int32_t length = EndianConvertBToL((int32_t)[enMessageData length]);
        fullData = [NSMutableData  dataWithBytes:&length length:sizeof(length)];
        [fullData appendBytes:&type length:sizeof(type)];
        [fullData appendData:enMessageData];
    }
    };
    if (dispatch_get_specific(socketQueueTag)) {
        block();
    }else{
        dispatch_sync(socketQueue, block);
    }
    return fullData;
}
/**
 *
 * @param message
 * @return data
 *
 **/
- (SendMessageType)sendMessageType:(Message *)message{
    __block SendMessageType result;
    dispatch_block_t block = ^{@autoreleasepool{
        if ([message isKindOfClass:[ChatMessage class]]) {
            result = ChatType;
        }else if ([message isKindOfClass:[HeartBeatMessage class]]) {
            result = HeartBeatType;
        } else if ([message isKindOfClass:[RequestMessage class]]) {
            result = RequestType;
        } else if ([message isKindOfClass:[ResponseMessage class]]) {
            result = ResponseType;
        } else if ([message isKindOfClass:[CommandMessage class]]){
            result = CommandType;
        }else {
            result = 6;
        }
    }
    };
    if (dispatch_get_specific(socketQueueTag)) {
        block();
    }else{
        dispatch_sync(socketQueue, block);
    }
    return result;
}
/**
 * @param message
 * @param timeout
 * @param type
 **/
- (void)sendMessage:(Message *)message timeout:(int)timeout type:(SendMessageType)type{
    dispatch_block_t block = ^{@autoreleasepool{
        [_writeMessageQueue setObject:message forKey:message.Id];
        NSData *messageData = [self dataWithMessage:message];
        if (_socket.isConnected) {
            [_socket writeData:messageData withTimeout:-1 tag:SocketSendMessage];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), timerQueue, ^{
                if ([_writeMessageQueue objectForKey:message.Id] != nil) {
                    [self sendMessageDidTimeoutWith:message type:type];
                }
            });
        }else{
            NSError *error = [NSError errorWithDomain:@"can not send message beause disConnect" code:SocketClientLostConnect userInfo:nil];
            DDLogError(@"%@", error);
            if (type == ChatType) {
                if (_delegate && [_delegate respondsToSelector:@selector(messageDidSendFail:)]) {
                    [_delegate messageDidSendFail:message];
                }
            }
            if (type == RequestType) {
                isAuthorizing = NO;
                isAuthorized = NO;
                if (_delegate && [_delegate respondsToSelector:@selector(authorizeDidFailWithType:reason:)]) {
                    [_delegate authorizeDidFailWithType:socketAuthorizeFailError reason:error.description];
                }
            }
            
            [_writeMessageQueue removeObjectForKey:message.Id];
        }
    }
        
    };
    if (dispatch_get_specific(socketQueueTag)) {
        block();
    }else{
        dispatch_async(socketQueue, block);
    }
}
/**
 * @param message
 * @param type
 **/
- (void)sendMessageDidTimeoutWith:(Message *)message type:(SendMessageType)type{
    dispatch_block_t block = ^{@autoreleasepool{
        if (type == ChatType) {
            if (_delegate && [_delegate respondsToSelector:@selector(messageDidSendTimeout:)]) {
                [_delegate messageDidSendTimeout:message];
            }
        }
        if (_delegate && type == RequestType) {
            if ([_delegate respondsToSelector:@selector(authorizeTimeout)]) {
                [_delegate authorizeTimeout];
            }
        }
        if (type == HeartBeatType) {
            if (_host) {
                [self reconnect];
            }
        }

        [_writeMessageQueue removeObjectForKey:message.Id];
    }
        
    };
    if (dispatch_get_specific(socketQueueTag)) {
        block();
    }else{
        dispatch_async(socketQueue, block);
    }
}
/**
 * keep alive
 **/
- (void)setKeepAliveInterval:(NSTimeInterval)interval
{
    dispatch_block_t block = ^{
        
        if (keepAliveInterval != interval)
        {
            if (interval <= 0.0)
                keepAliveInterval = interval;
            else
                keepAliveInterval = MAX(interval, MIN_KEEPALIVE_INTERVAL);
            
            [self setupKeepAliveTimer];
        }
    };
    
    if (dispatch_get_specific(socketQueueTag))
        block();
    else
        dispatch_async(socketQueue, block);
}
- (void)setupKeepAliveTimer{
    if (timerSource){
        dispatch_source_cancel(timerSource);
        timerSource = NULL;
    }
    if ([self isConnected]) {
        timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, socketQueue);
        dispatch_source_set_timer(timerSource, DISPATCH_TIME_NOW, keepAliveInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timerSource, ^{
            [self keepAlive];
        });
        dispatch_resume(timerSource);
    }
}

- (void)keepAlive{
    if ([self isConnected]) {
        HeartBeatMessage *heartBeatMessage = [[HeartBeatMessage alloc] initWithId:[[NSUUID UUID] UUIDString]];
        [self sendMessage:heartBeatMessage timeout:5 type:HeartBeatType];
    }else{
        if (_host) {
            [self reconnect];
        }
    }
}

@end
