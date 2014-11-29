//
//  HttpReqpuest.m
//  IMSDK
//
//  Created by foreveross－bj on 14-11-21.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest ()
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSURL *URL;
@end
@implementation HttpRequest

- (id)initWithUrl:(NSString *)url{
    self = [super init];
    if (self) {
        self.URL = [NSURL URLWithString:url];
        self.request = [[NSMutableURLRequest alloc] initWithURL:self.URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    }
    return self;
}

- (void)setHttpMethod:(NSString *)method{
    self.request.HTTPMethod = method;
}
- (void)setHttpBody:(NSString *)body{
    self.request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
}
- (void)addHeader:(NSString *)header forKey:(NSString *)key{
    [self.request addValue:header forHTTPHeaderField:key];
}
- (void)addHeadersWithDictionary:(NSDictionary *)dictionary{
    if (dictionary != nil) {
        for (NSString *key in dictionary) {
            [self addHeader:dictionary[key] forKey:key];
        }
    }
}

- (void)startRequtstWithSuccess:(void (^)(NSData *))success fail:(void (^)(NSError *))fail{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:self.request queue:queue   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            if (success != nil) {
                success(data);
            }
        }else{
            if (fail != nil) {
                fail(connectionError);
            }
        }
    }];
}
@end
