//
//  Tools.h
//  IMSDK
//
//  Created by foreveross－bj on 14-10-30.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import <Foundation/Foundation.h>

const static int ENCRYPT = 1;
const static int DECRYPT = -1;


@interface Tools : NSObject

/**
 * @param sting
 *
 * 将nil字符串转换成""
 **/
+ (NSString *)sEmpty:(NSString *)String;
/**
 * @param array
 *
 * 将nil数组转换成@[]
 **/
+ (NSArray *)aEmpty:(NSArray *)array;
/**
 * @param dictionary
 *
 * 将nil字典转换成@{}
 **/
+ (NSDictionary *)dEmpty:(NSDictionary *)dictionary;
/**
 * @param data
 *
 * 将nil data转换成空字符流
 **/
+ (NSData *)bEmpty:(NSData *)data;
/**
 * @param string
 * 判断字符串是否为空
 **/
+ (BOOL)isBlankString:(NSString *)string;
/**
 * @param srcString
 * 16位MD5加密方式
 **/
+ (NSString *)getMd5_16Bit_String:(NSString *)srcString;
/**
 * @param srcString
 * 16位MD5加密方式
 **/
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;
/**
 * @param password
 * 对密码加密
 **/
+ (NSString *)encode:(NSString *)password;
/**
 * @param message
 * @param key
 * @param methon
 * 对消息体加密解密
 **/
+ (NSData *)encryptionWithMessage:(NSData *)message key:(Byte)key methon:(int)methon;

/**
 * @param IputNum
 * 大端模式转小端模式
 * 小端模式转大端模式
 **/
int32_t EndianConvertLToB(int32_t InputNum);
int32_t EndianConvertBToL(int32_t InputNum);


 @end
