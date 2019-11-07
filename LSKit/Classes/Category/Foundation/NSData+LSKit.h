//
//  NSData+LSKit.h
//  LSKit
//
//  Created by Lyson on 2019/9/13.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (LSKit)

/**
 AES加密

 @param key key
 @param iv iv
 @return 结果
 */
- (NSData *)ls_AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;

/**
 AES解密

 @param key key
 @param iv iv
 @return 加密结果
 */
- (NSData *)ls_AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;

/**
 AES加密

 @param operation 加密解密
 @param key key
 @param iv iv
 @return 结果
 */
- (NSData *)ls_AES128Operation:(CCOperation)operation
                           key:(NSString *)key
                            iv:(NSString *)iv;

/**
 ECB AES 128

 @param operation 加密解密
 @param key key
 @param iv iv
 @return 结果
 */
- (NSData *)ls_AES128ECBOperation:(CCOperation)operation
                              key:(NSString *)key
                               iv:(NSString *)iv;

/**
 base 64解码

 @param value value
 @return 解码结果
 */
+ (NSData *)ls_dataWithBase64EncodedString:(NSString *)value;

/**
 编码base 64

 @return 64编码
 */
- (NSString *)ls_base64EncodedString;

@end
