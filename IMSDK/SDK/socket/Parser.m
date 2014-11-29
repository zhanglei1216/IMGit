//
//  Parser.m
//  IMSDK
//
//  Created by foreveross－bj on 14-11-20.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "Parser.h"
#import "Tools.h"
#import "MPMessagePack.h"
#import "MessageHeader.h"
#import "CreateMessage.h"
@interface Parser ()
{
    dispatch_queue_t parserQueue;
    dispatch_queue_t delegateQueue;
    void *parserQueueTag;
    NSMutableData *_readData;
    NSUInteger _dataLength;
    SendMessageType _sendMessageType;
    NSMutableArray *_readMessageQueue;
}
@property (nonatomic, strong) NSMutableData *readData;
@property (nonatomic, strong) NSMutableArray *readMessageQueue;
@end

@implementation Parser
/**
 * @param delegate
 * @param queue
 **/
- (id)initWithDelegate:(id<ParserDelegate>)delegate delegateQueue:(dispatch_queue_t)queue{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        delegateQueue = queue;
        
        #if !OS_OBJECT_USE_OBJC
        if (delegateQueue)
            dispatch_retain(delegateQueue);
        #endif
        self.readData = [[NSMutableData alloc] init];
        parserQueue = dispatch_queue_create("parser", NULL);
        parserQueueTag = &parserQueueTag;
        dispatch_queue_set_specific(parserQueue, parserQueueTag, parserQueueTag, NULL);
        self.readMessageQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
    if (delegateQueue)
        dispatch_release(delegateQueue);
    if (parserQueue)
        dispatch_release(parserQueue);
#endif
}
- (void)setDelegate:(id)newDelegate delegateQueue:(dispatch_queue_t)newDelegateQueue{
#if !OS_OBJECT_USE_OBJC
    if (newDelegateQueue)
        dispatch_retain(newDelegateQueue);
#endif
    
    dispatch_block_t block = ^{
        
        _delegate = newDelegate;
        
#if !OS_OBJECT_USE_OBJC
        if (delegateQueue)
            dispatch_release(delegateQueue);
#endif
        
        delegateQueue = newDelegateQueue;
    };
    
    if (dispatch_get_specific(parserQueueTag))
        block();
    else
        dispatch_async(parserQueue, block);
}
/**
 * @param data
 * @param type
 * transform data to message
 **/
- (void)paraseData:(NSData *)data type:(HandleMessageType)type{
    dispatch_block_t block = ^{@autoreleasepool{
        if (type == SocketReadHeader) {
            [self.readData appendData:data];
            if (self.readData.length < kHeaderLength) {
                if (_delegate && [_delegate respondsToSelector:@selector(readToLength:tag:)]) {
                    __strong id theDelegate = _delegate;
                    dispatch_async(delegateQueue, ^{@autoreleasepool{
                        [theDelegate readToLength:kHeaderLength - self.readData.length tag:SocketReadHeader];
                    }
                    });
                }
            }else{
                [self.readData getBytes:&_dataLength range:NSMakeRange(0, 4)];
                [self.readData getBytes:&_sendMessageType range:NSMakeRange(4, 1)];
                self.readData = [[NSMutableData alloc] init];
                _dataLength = EndianConvertLToB((int32_t)_dataLength);
                NSLog(@"%lu", (unsigned long)_dataLength);
                if (_delegate && [_delegate respondsToSelector:@selector(readToLength:tag:)]) {
                    __strong id theDelegate = _delegate;
                    dispatch_async(delegateQueue, ^{@autoreleasepool{
                         [theDelegate readToLength:_dataLength tag:SocketReadBody];
                    }
                    });
                }
            }
        }
        if (type == SocketReadBody) {
            [self.readData appendData:data];
            if (self.readData.length < _dataLength) {
                if (_delegate && [_delegate respondsToSelector:@selector(readToLength:tag:)]) {
                    __strong id theDelegate = _delegate;
                    dispatch_async(delegateQueue, ^{@autoreleasepool{
                        
                        [theDelegate readToLength:_dataLength - self.readData.length tag:SocketReadBody];
                    }
                    });
                    
                }
            }else{
                if (_delegate && [_delegate respondsToSelector:@selector(readMessageWithMessage:)]) {
                    [_readMessageQueue addObject:[self messageParserWithData:_readData type:_sendMessageType]];
                    dispatch_async(delegateQueue, ^{@autoreleasepool{
                        __strong id theDelegate = _delegate;
                        [theDelegate readMessageWithMessage:_readMessageQueue];
                    }
                    });
                }
                self.readData = [[NSMutableData alloc] init];
                _dataLength = 0;
                if ( _delegate && [_delegate respondsToSelector:@selector(readToLength:tag:)]) {
                    __strong id theDelegate = _delegate;
                    dispatch_async(delegateQueue, ^{@autoreleasepool{
                         [theDelegate readToLength:kHeaderLength tag:SocketReadHeader];
                    }
                    });
                   
                }
            }
        }
    }};
    if (dispatch_get_specific(parserQueueTag)) {
        block();
    }else{
        dispatch_async(parserQueue, block);
    }
}
/**
 * @param data
 * @param type
 * tranform data to message
 **/
- (Message *)messageParserWithData:(NSData *)data type:(SendMessageType)type{
    __block Message *message = nil;
    dispatch_block_t block = ^{@autoreleasepool{
        NSData *data = [Tools encryptionWithMessage:_readData key:_readData.length % 8 methon:DECRYPT];
        NSError *error = nil;
        message = [CreateMessage messageWithData:data type:type error:&error];
        if (error != nil) {
            DDLogError(@"%@", error);
        }
    }
    };
    if (dispatch_get_specific(parserQueueTag)) {
        block();
    }else{
        dispatch_sync(parserQueue, block);
    }
    return message;
}
@end
