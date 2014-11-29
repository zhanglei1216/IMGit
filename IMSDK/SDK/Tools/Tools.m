//
//  Tools.m
//  IMSDK
//
//  Created by foreveross－bj on 14-10-30.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Tools
/**
 *@param sting
 *
 *将nil字符串转换成""
 **/
+ (NSString *)sEmpty:(NSString *)String
{
    if (String == nil) {
        return @"";
    }
    return String;
}
/**
 *@param array
 *
 *将nil数组转换成@[]
 **/
+ (NSArray *)aEmpty:(NSArray *)array
{
    if (array == nil) {
        return @[];
    }
    return array;
}
/**
 *@param dictionary
 *
 *将nil字典转换成@{}
 **/
+ (NSDictionary *)dEmpty:(NSDictionary *)dictionary
{
    if (dictionary == nil) {
        return @{};
    }
    return dictionary;
}
/**
 *@param data
 *
 *将nil data转换成空字符流
 **/
+ (NSData *)bEmpty:(NSData *)data
{
    if (data == nil) {
        return [NSData data];
    }
    return data;
}
/**
 * @param string
 * 判断字符串是否为空
 **/
+ (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    if ([string isEqualToString:@"(null)"]) {
        
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}

//16位MD5加密方式
+ (NSString *)getMd5_16Bit_String:(NSString *)srcString{
    //提取32位MD5散列的中间16位
    NSString *md5_32Bit_String=[self getMd5_32Bit_String:srcString];
    NSString *result = [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];//即9～25位
    
    return result;
}


//32位MD5加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

+ (NSString *)encode:(NSString *)password{
    const char *cStr = [password UTF8String];
    unsigned char passBytes[CC_MD5_DIGEST_LENGTH];
    md(cStr, passBytes);
     uint8_t passHash[CC_SHA256_DIGEST_LENGTH];
    sha256([[self hex:passBytes] UTF8String], passHash);
    return [self hex:passHash];
}

void md(const char * cStr, Byte * byte){
    CC_MD5( cStr, (unsigned int)strlen(cStr), byte);
    if (strlen((const char *)byte) > 16) {
        byte[16] = '\0';
    }else if(strlen((const char *)byte) < 16){
        for (int i = (int)strlen((const char *)byte); i < 16; i++) {
            byte[i] = 0x0;
        }
        byte[16] = '\0';
    }
}

void sha256(const char * cStr, Byte * bytes){
    CC_SHA256(cStr, (unsigned int)strlen(cStr), bytes);
    if (strlen((const char *)bytes) > 32) {
        bytes[32] = '\0';
    }else if(strlen((const char *)bytes) < 32){
        for (int i = (int)strlen((const char *)bytes); i < 32; i++) {
            bytes[i] = 0x0;
        }
        bytes[32] = '\0';
    }
}

+ (NSString *)hex:(Byte *)bytes{
    //下面是Byte 转换为16进制。
    int count = 0;
    if (strlen((const char *)bytes) > 16) {
        count = 32;
    }else{
        count = 16;
    }
    NSString *hexStr=@"";
    for(int i=0;i < count;i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
}

//sha1加密方式
+ (NSString *)getSha1String:(NSString *)srcString{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

//sha256加密方式
+ (NSString *)getSha256String:(NSString *)srcString {
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

//sha384加密方式
+ (NSString *)getSha384String:(NSString *)srcString {
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA384_DIGEST_LENGTH];
    
    CC_SHA384(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

//sha512加密方式
+ (NSString*) getSha512String:(NSString*)srcString {
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

#pragma mark - 
#pragma mark - Encryption

+ (NSData *)encryptionWithMessage:(NSData *)message key:(Byte)key methon:(int)methon{
    long count = message.length;
     char *src = (char *)message.bytes;
    NSMutableData *result = [[NSMutableData alloc] init];
    for (long i = 0; i < count; i++) {
         Byte r = encyp(src[i], key, methon);
        [result appendBytes:&r length:sizeof(r)];
    }
    return result;
}

char encyp(char src, char key, int methon){
    int p = methon * (key % 8);
    p = p > 0 ? p : p + 8;
    int nSrc = src & 255;
    int mask = (int)pow(2,p) - 1;
    int  tmp = nSrc & mask;
    
    nSrc >>= p;
    tmp <<= (8 - p);
    nSrc |= tmp;
    return (char)nSrc;
}

int32_t EndianConvertLToB(int32_t InputNum) {
    NSData *lData = [NSData dataWithBytes:&InputNum length:sizeof(InputNum)];
    NSMutableData *bData = [NSMutableData data];
    for ( int i = 3; i >= 0 ; i--) {
        Byte y;
        [lData getBytes:&y range:NSMakeRange(i, 1)];
        [bData appendBytes:&y length:1];
    }
    int32_t result;
    [bData getBytes:&result length:sizeof(result)];
    return result;
}
int32_t EndianConvertBToL(int32_t InputNum) {
    NSData *bData = [NSData dataWithBytes:&InputNum length:sizeof(InputNum)];
    NSMutableData *lData = [NSMutableData data];
    for ( int i = 3; i >= 0 ; i--) {
        Byte y;
        [bData getBytes:&y range:NSMakeRange(i, 1)];
        [lData appendBytes:&y length:1];
    }
    int32_t result;
    [lData getBytes:&result length:sizeof(result)];
    return result;
}
@end
