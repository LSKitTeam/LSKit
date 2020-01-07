//
//  NSString+LSKit.m
//  LSKit
//
//  Created by Lyson on 2019/9/14.
//

#import "NSString+LSKit.h"
#import "NSData+LSKit.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LSKit)

/// 数字正则
- (BOOL)ls_isNumber {
    if (self.length == 0) return NO;
    NSString *isNumber = @"^[0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", isNumber];
    return [predicate evaluateWithObject:self];
}

/// 字母正则
- (BOOL)ls_isLetters {
    if (self.length == 0) return NO;
    NSString *phoneRegex = @"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [predicate evaluateWithObject:self];
}

/// 判断是否可用
- (BOOL)ls_isAvailable {
    return (self && [self isKindOfClass:[NSString class]] && self.length != 0 && ![self isKindOfClass:[NSNull class]] && self != NULL && ![self isEqualToString:@"<null>"] && ![self isEqualToString:@"(null)"]);
}

/**
 URL编码

 @return URL编码
 */
- (NSString *)ls_urlEncodedString {
    //!*'();:@&=+$,/?%#[]
    NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"!\" #$%&'()*+,/:;<=>?@[\\]^`{|}~"] invertedSet];

    NSString *result = [self stringByAddingPercentEncodingWithAllowedCharacters:charSet];
    return result;
}

/**
 URL解码

 @return URL解码
 */
- (NSString *)ls_urlDecodedString {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
            CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
            NULL,
            (__bridge CFStringRef)decoded,
            CFSTR(""),
            en);
        return decoded;
#pragma clang diagnostic pop
    }
}

/**
 MD5

 @return MD5
 */
- (NSString *)ls_md5EncodeString {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)self.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }

    return result;
}

/**
 判断字符串为空

 @param value value
 @return YES NO
 */
+ (BOOL)ls_empty:(NSString *)value {
    value = [value ls_stringByTrim];

    if (!value) {
        return YES;
    }
    if (![value isKindOfClass:[NSString class]]) {
        return YES;
    }
    return value.length == 0;
}

/**
 去除首尾空格

 @return String
 */
- (NSString *)ls_stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

/**
 base64编码

 @return 编码结果
 */
- (NSString *)ls_base64EncodedString {
    NSData *data =
        [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data ls_base64EncodedString];
}

/**
 base64解码

 @return 编码结果
 */
- (NSString *)ls_base64DecodedString {
    return [NSString ls_stringWithBase64EncodedString:self];
}

+ (NSString *)ls_stringWithBase64EncodedString:(NSString *)string {
    NSData *data = [NSData ls_dataWithBase64EncodedString:string];
    if (data) {
        return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
