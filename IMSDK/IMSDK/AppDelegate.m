//
//  AppDelegate.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-29.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "AppDelegate.h"
#import "ChatMessage.h"
#import <CommonCrypto/CommonDigest.h>
#import "GroupViewController.h"

//#define Host @"127.0.0.1"
//#define Host @"www.applutai.com"
//#define Port 5222
//#define Host @"192.168.0.102"
//#define Host @"192.168.100.125"
//#define Port 10000
//#define Port 49575

@interface AppDelegate ()
@property (nonatomic, strong) ConnectSocket *socket;
@property (nonatomic, strong) DoRegister *doRegister;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) int port;
@end

@implementation AppDelegate 


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 120, 60);
    [button setTitle:@"Send Message" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(100, 200, 120, 60);
    [button1 setTitle:@"connect" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(100, 300, 120, 60);
    [button2 setTitle:@"register" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(Register) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    button3.frame = CGRectMake(100, 400, 120, 60);
    [button3 setTitle:@"reconnect" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(reconnect) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    button4.frame = CGRectMake(100, 470, 120, 60);
    [button4 setTitle:@"groupHandle" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(groupHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:button4];
    
    _socket = [[ConnectSocket alloc] initWithDelegate:self];
    self.doRegister = [[DoRegister alloc] initWithDelegate:self];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (void)groupHandle{
    GroupViewController *groupViewController = [[GroupViewController alloc] init];
    self.window.rootViewController = groupViewController;
}
- (void)reconnect{
    [self reconnect];
}
- (void)Register{
    
    NSString *password = @"123456";
    NSString *JSONParam = [NSString stringWithFormat:@"{ \"appId\": \"MYAPPID\", \"deviceId\": \"MYDEVICEID\", \"secret\":\"MYSECRET\",\"devicePlatform\":\"iOS\",\"ssl\":\"true\",\"username\": \"zhanglei\", \"password\":\"%@\", \"encryption\": \"true\"}", [Tools encode:password]];
    NSLog(@"%@", [Tools encode:password]);
    [_doRegister registerWithURL:@"http://192.168.0.99:8080/api/client/register" jsonParam:JSONParam];
}
- (void)send{
    ImageChatMessage *imageChatMessage = [[ImageChatMessage alloc] initWithId:[[NSUUID UUID] UUIDString] from:@"T#zhanglei" to:@"T#lujun" timestamp:[[NSDate date] timeIntervalSince1970]];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mov"];
    imageChatMessage.thumbContent = [NSData dataWithContentsOfFile:filePath];
    NSLog(@"%lu", (unsigned long)[imageChatMessage.data length]);
//    TextChatMessage *textChatMessage = [[TextChatMessage alloc] initWithId:[[NSUUID UUID] UUIDString] to:@"T#lujun" from:@"T#zhanglei" timestap:[[NSDate date] timeIntervalSince1970]];
//    textChatMessage.content = @"你好";
    [_socket sendMessage:imageChatMessage];
    
//    TextChatMessage *textChatMessage = [TextChatMessage alloc] initWithId:@"" to:<#(NSString *)#> from:<#(NSString *)#> timestap:<#(long)#>
    
}
- (void)connect{
    [_socket connectWithIp:_host port:_port];
}
- (void)registerWillBegin{
     NSLog(@"%s %d", __FUNCTION__, __LINE__);
}
- (void)registerDidSuccessWithResult:(NSString *)result
{
    NSLog(@"%@", result);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    _host = dic[@"host"];
    _token = dic[@"sessionToken"];
    _port = [dic[@"port"] intValue];
}
- (void)registerDidFailWithType:(int)type reason:(NSString *)reason{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
    NSLog(@"type=%d, reason=%@", type, reason);
}
- (void)connectWillBegin{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}
- (void)connectDidSuccess{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
    TokenRequestMessage *token = [[TokenRequestMessage alloc] initWithId:[[NSUUID UUID] UUIDString] token:_token];
    [_socket authorizeWithMessage:token];
}
- (void)authorizeWillBegin{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}
- (void)authorizeDidSuccess{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}
- (void)authorizeTimeout{
    NSLog(@"%@", [NSThread currentThread]);
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}
- (void)authorizeDidFailWithType:(int)type reason:(NSString *)reason
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
    NSLog(@"type=%d, reason=%@", type, reason);
}
- (void)connectDidTimeout{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}
- (void)connectDidFailWithType:(int)type reason:(NSString *)reason{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
    NSLog(@"%d", type);
    NSLog(@"%@", reason);
}
- (void)connectWillAbort{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}
- (void)connectDidAbort{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}
- (void)messageDidReceived:(Message *)message{
     NSLog(@"%s %d", __FUNCTION__, __LINE__);
    if ([message isKindOfClass:[ImageChatMessage class]]) {
        ImageChatMessage *textMessage = (ImageChatMessage *)message;
        NSLog(@"id = %@, content = %@", textMessage.Id, textMessage.thumbContent);
    }else{
        TextChatMessage *textMessage = (TextChatMessage *)message;
        NSLog(@"id = %@, content = %@", textMessage.Id, textMessage.content);
    }
}
- (void)messageDidSendSuccess:(Message *)message{
    ChatMessage *chat = (ChatMessage *)message;
     NSLog(@"%s %d", __FUNCTION__, __LINE__);
    NSLog(@"%@, %d, %@", chat.Id, chat.msgType, chat.from);
}
- (void)messageDidSendTimeout:(Message *)message{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
