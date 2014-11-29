//
//  DoRegister.h
//  IMSDK
//
//  Created by foreveross－bj on 14-11-17.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark - protocol
@protocol registerDelegate <NSObject>
@optional
- (void)registerWillBegin;
/**
 * @param result
 **/
- (void)registerDidSuccessWithResult:(NSString *)result;
/**
 * @param type
 * @param reason
 **/
- (void)registerDidFailWithType:(int)type reason:(NSString *)reason;

@end

@interface DoRegister : NSObject

#pragma mark -
#pragma mark - attribute
@property (nonatomic, assign) id<registerDelegate> delegate;

#pragma mark -
#pragma mark - Initialized and Creating
/**
 * @param delegate
 **/
- (id)initWithDelegate:(id<registerDelegate>)delegate;

#pragma mark -
#pragma mark - Function
/**
 * @param url
 * @param jsonParam
 **/
- (void)registerWithURL:(NSString *)url jsonParam:(NSString *)jsonParam;

@end
