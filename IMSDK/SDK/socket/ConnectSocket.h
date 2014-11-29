//
//  ConnectSocket.h
//  IMSDK
//
//  Created by foreveross－bj on 14-10-29.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "CreateMessage.h"
#import "Parser.h"

#pragma mark -
#pragma mark - protocol
@protocol SocketDelegate <NSObject>
@optional

- (void)connectWillBegin;
- (void)connectDidSuccess;
/**
 * @param type
 * @param reason
 **/
- (void)connectDidFailWithType:(int)type reason:(NSString *)reason;
- (void)connectDidTimeout;
- (void)connectWillAbort;
- (void)connectDidAbort;
/**
 * @param message
 **/
- (void)messageWillSend:(Message *)message;
/**
 * @param message
 **/
- (void)messageDidSendSuccess:(Message *)message;
/**
 * @param message
 **/
- (void)messageDidSendFail:(Message *)message;
/**
 * @param message
 **/
- (void)messageDidSendTimeout:(Message *)message;
/**
 * @param message
 **/
- (void)messageDidReceived:(Message *)message;
- (void)authorizeWillBegin;
- (void)authorizeDidSuccess;
- (void)authorizeTimeout;
/**
 * @param type
 * @param reason
 **/
- (void)authorizeDidFailWithType:(int)type reason:(NSString *)reason;
@end

@interface ConnectSocket : NSObject <GCDAsyncSocketDelegate, ParserDelegate>


#pragma mark - 
#pragma mark - attribute
@property (nonatomic, assign) id<SocketDelegate> delegate;

#pragma mark - 
#pragma mark - Initialized and Creating
/**
 * @param delegate
 **/
- (id)initWithDelegate:(id<SocketDelegate>)delegate;

#pragma mark -
#pragma mark - Function

/**
 * @param ip
 * @param port
 **/
- (void)connectWithIp:(NSString *)ip port:(int)port;
/**
 * disConnect
 **/
- (void)disconnect;
/**
 * send message
 **/
- (void)sendMessage:(Message *)message;
/**
 * @return BOOL
 **/
- (BOOL)isConnected;
/**
 * reconnect;
 **/
- (void)reconnect;
/**
 * @param message
 **/
- (void)authorizeWithMessage:(Message *)message;
/**
 * set heartbeat cycle.
 * @param interval
 **/
- (void)setKeepAliveInterval:(NSTimeInterval)interval;
@end
