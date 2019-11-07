//
//  NSString+LSKit.h
//  LSKit
//
//  Created by Lyson on 2019/9/14.
//

#import <Foundation/Foundation.h>

@interface NSString (LSKit)

/**
 判断字符串为空 去掉首尾空格

 @param value value
 @return YES NO
 */
+ (BOOL)ls_empty:(NSString *)value;

/**
 去除首尾空格

 @return String
 */
- (NSString *)ls_stringByTrim;

/**
 base64编码

 @return 编码结果
 */
- (NSString *)ls_base64EncodedString;

/**
 base64解码

 @return 编码结果
 */
- (NSString *)ls_base64DecodedString;

/**
 MD5
 
 @return MD5
 */
- (NSString *)ls_md5EncodeString;

/**
 URL编码
 
 @return URL编码
 */
- (NSString *)ls_urlEncodedString;

/**
 URL解码
 
 @return URL解码
 */
- (NSString*)ls_urlDecodedString;

@end
