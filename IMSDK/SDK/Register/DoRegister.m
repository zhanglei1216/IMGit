//
//  DoRegister.m
//  IMSDK
//
//  Created by foreveross－bj on 14-11-17.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "DoRegister.h"
#import "HttpRequest.h"

@interface DoRegister ()
{
    dispatch_queue_t willRegisterQueue;
}
@end

@implementation DoRegister
/**
 * @param delegate
 **/
- (id)initWithDelegate:(id<registerDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        willRegisterQueue = dispatch_queue_create("willRegister", NULL);
    }
    return self;
}
- (void)dealloc{
#if !OS_OBJECT_USE_OBJC
    dispatch_release(willRegisterQueue);
#endif
}
/**
 * @param url
 * @param jsonParam
 **/
- (void)registerWithURL:(NSString *)url jsonParam:(NSString *)jsonParam{
    if ([_delegate respondsToSelector:@selector(registerWillBegin)]) {
        dispatch_async(willRegisterQueue, ^{@autoreleasepool{
            [_delegate registerWillBegin];
            [self startRuquestWithURL:url jsonParam:jsonParam];
        }
        });
    }else{
        [self startRuquestWithURL:url jsonParam:jsonParam];
    }
}
/**
 * @param url
 * @param jsonParam
 **/
- (void)startRuquestWithURL:(NSString *)url jsonParam:(NSString *)jsonParam{
    HttpRequest *httpRequest = [[HttpRequest alloc] initWithUrl:url];
    [httpRequest setHttpMethod:@"POST"];
    [httpRequest setHttpBody:jsonParam];
    NSDictionary *headerDic = @{@"Content-Type":@"application/json;charset=UTF-8", @"Accept-Charset":@"UTF-8"};
    [httpRequest addHeadersWithDictionary:headerDic];
    [httpRequest startRequtstWithSuccess:^(NSData *result) {
        if (_delegate && [_delegate respondsToSelector:@selector(registerDidSuccessWithResult:)]) {
            [_delegate registerDidSuccessWithResult:[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]];
        }
    } fail:^(NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(registerDidFailWithType:reason:)]) {
            [_delegate registerDidFailWithType:(int)error.code reason:error.localizedDescription];
        }
    }];
}
@end
