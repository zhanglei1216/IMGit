//
//  IMSDKTests.m
//  IMSDKTests
//
//  Created by foreveross－bj on 14-10-29.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CommandMessage.h"
#import "MPMessagePack.h"
#import "RequestMessage.h"
#import "GroupUserAddCmdMessage.h"
#import "ResponseMessage.h"
#import "ConnectSocket.h"
#import "Tools.h"
@interface IMSDKTests : XCTestCase <SocketDelegate>

@end

@implementation IMSDKTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
//    GroupUserAddCmdMessage *g = [[GroupUserAddCmdMessage alloc] initWithGroupId:nil optUser:nil users:nil];
//    NSDictionary *dic = [MPMessagePackReader readData:g.data error:nil];
//    NSLog(@"%@", dic);
//    NSLog(@"%d", g.hash);
//    RequestMessage *requestMessage = [[RequestMessage alloc] initWithRequestType:23];
//    NSLog(@"%d", requestMessage.requestType);
//    ResponseMessage *re = [[ResponseMessage alloc] initWithId:nil code:0 message:nil responseTime:0];
//    int a = 10000;
//    Byte c = 16;
//    NSMutableData *data = [NSMutableData dataWithBytes:&a length:sizeof(a)];
//    [data appendBytes:&c length:sizeof(c)];
//    NSLog(@"%lu", (unsigned long)data.length);
//    int b;
//    Byte d;
//    [data getBytes:&b range:NSMakeRange(0, 4)];
//    [data getBytes:&d range:NSMakeRange(4, 1)];
//    NSLog(@"%d ,%d", b, d);
//    NSLog(@"%@", [Tools encode:@"123"]);
    NSString *string = @"abc";
    NSData *data2 = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data3 = [Tools encryptionWithMessage:data2 key:data2.length methon:1];
    TokenRequestMessage *token = [[TokenRequestMessage alloc] initWithId:[[NSUUID UUID]UUIDString] token:@"abc"];
    NSData *message = [Tools encryptionWithMessage:token.data key:token.data.length % 8 methon:1];
    NSData *data4 = [Tools encryptionWithMessage:message key:message.length % 8 methon:-1];
    TokenRequestMessage *t = [[TokenRequestMessage alloc] init];
    [t setValuesForKeysWithDictionary:[MPMessagePackReader readData:data4 error:nil]];
    NSLog(@"%@", t.token);
    NSDictionary *dic = nil;
    for (NSString *key in dic) {
        
    }
    
//    int32_t a = 16;
//    int32_t b = [self lBytesToData:11111114];
    
//    [data getBytes:&b length:4];
//    NSLog(@"%d", b);
    XCTAssert(YES, @"Pass");
    
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
