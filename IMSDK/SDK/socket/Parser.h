//
//  Parser.h
//  IMSDK
//
//  Created by foreveross－bj on 14-11-20.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Socket.h"

#pragma mark -
#pragma mark - protocol
@protocol ParserDelegate <NSObject>

- (void)readMessageWithMessage:(NSMutableArray *)messageQueue;
- (void)readToLength:(NSUInteger)length tag:(long)tag;

@end

@interface Parser : NSObject

#pragma mark -
#pragma mark - attribute
@property (nonatomic, assign) id<ParserDelegate> delegate;

#pragma mark -
#pragma mark - Initialized and Creating
/**
 * @param delegate
 * @param queue
 **/
- (id)initWithDelegate:(id<ParserDelegate>)delegate delegateQueue:(dispatch_queue_t)queue;
#pragma mark -
#pragma mark - Function
/**
 * @param data
 * @param type
 * append data to full data
 **/
- (void)paraseData:(NSData *)data type:(HandleMessageType)type;

/**
 * @param newDelegate
 * @param newDelegateQueue
 **/
- (void)setDelegate:(id)newDelegate delegateQueue:(dispatch_queue_t)newDelegateQueue;

@end
