//
//  AppDelegate.h
//  IMSDK
//
//  Created by foreveross－bj on 14-10-29.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectSocket.h"
#import "DoRegister.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SocketDelegate, registerDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

