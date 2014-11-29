//
//  HttpReqpuest.h
//  IMSDK
//
//  Created by foreveross－bj on 14-11-21.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject

- (id)initWithUrl:(NSString *)url;
- (void)setHttpMethod:(NSString *)method;
- (void)setHttpBody:(NSString *)body;
- (void)addHeader:(NSString *)header forKey:(NSString *)key;
- (void)addHeadersWithDictionary:(NSDictionary *)dictionary;
- (void)startRequtstWithSuccess:(void (^)(NSData *result))success fail:(void (^)(NSError *error))fail;

@end
