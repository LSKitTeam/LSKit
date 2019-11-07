//
//  NSData+LSKit.m
//  LSKit
//
//  Created by Lyson on 2019/9/13.
//

#import "NSData+LSKit.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (LSKit)

/**
 AES加密

 @param key key
 @param iv iv
 @return 结果
 */
- (NSData *)ls_AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv {
    return [self ls_AES128Operation:kCCEncrypt key:key iv:iv];
}

/**
 AES解密

 @param key key
 @param iv iv
 @return 加密结果
 */
- (NSData *)ls_AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv {
    return [self ls_AES128Operation:kCCDecrypt key:key iv:iv];
}

/**
 ECB AES 128

 @param operation 加密解密
 @param key key
 @param iv iv
 @return 结果
 */
- (NSData *)ls_AES128ECBOperation:(CCOperation)operation
                              key:(NSString *)key
                               iv:(NSString *)iv {
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr
          maxLength:sizeof(keyPtr)
           encoding:NSUTF8StringEncoding];

    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);

    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(
        operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
        keyPtr, kCCBlockSizeAES128, ivPtr, [self bytes], dataLength, buffer,
        bufferSize, &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
    }
    free(buffer);
    return nil;
}

/**
 AES加密

 @param operation 加密解密
 @param key key
 @param iv iv
 @return 结果
 */
- (NSData *)ls_AES128Operation:(CCOperation)operation
                           key:(NSString *)key
                            iv:(NSString *)iv {
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr
          maxLength:sizeof(keyPtr)
           encoding:NSUTF8StringEncoding];

    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);

    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus =
        CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding, keyPtr,
                kCCBlockSizeAES128, ivPtr, [self bytes], dataLength, buffer,
                bufferSize, &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
    }
    free(buffer);
    return nil;
}

/**
 编码base 64

 @return 64编码
 */
- (NSString *)ls_base64EncodedString {
    return [self ls_base64EncodedStringWithWrapWidth:0];
    ;
}

/**
 base 64解码

 @param value value
 @return 解码结果
 */
+ (NSData *)ls_dataWithBase64EncodedString:(NSString *)value {
    const char lookup[] = {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
        99, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99};

    NSData *inputData = [value dataUsingEncoding:NSASCIIStringEncoding
                            allowLossyConversion:YES];
    long long inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];

    long long maxOutputLength = (inputLength / 4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:maxOutputLength];
    unsigned char *outputBytes = (unsigned char *) [outputData mutableBytes];

    int accumulator = 0;
    long long outputLength = 0;
    unsigned char accumulated[] = {0, 0, 0, 0};
    for (long long i = 0; i < inputLength; i++) {
        unsigned char decoded = lookup[inputBytes[i] & 0x7F];
        if (decoded != 99) {
            accumulated[accumulator] = decoded;
            if (accumulator == 3) {
                outputBytes[outputLength++] =
                    (accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] =
                    (accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] =
                    (accumulated[2] << 6) | accumulated[3];
            }
            accumulator = (accumulator + 1) % 4;
        }
    }

    // handle left-over data
    if (accumulator > 0) {
        outputBytes[outputLength] =
            (accumulated[0] << 2) | (accumulated[1] >> 4);
    } else if (accumulator > 1) {
        outputBytes[++outputLength] =
            (accumulated[1] << 4) | (accumulated[2] >> 2);
    } else if (accumulator > 2) {
        outputLength++;
    }

    // truncate data to match actual output length
    outputData.length = outputLength;
    return outputLength ? outputData : nil;
}

- (NSString *)ls_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth {
    // ensure wrapWidth is a multiple of 4
    wrapWidth = (wrapWidth / 4) * 4;

    const char lookup[] =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    long long inputLength = [self length];
    const unsigned char *inputBytes = [self bytes];

    long long maxOutputLength = (inputLength / 3 + 1) * 4;
    maxOutputLength += wrapWidth ? (maxOutputLength / wrapWidth) * 2 : 0;
    unsigned char *outputBytes = (unsigned char *) malloc(maxOutputLength);

    long long i;
    long long outputLength = 0;
    for (i = 0; i < inputLength - 2; i += 3) {
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) |
                                             ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[((inputBytes[i + 1] & 0x0F) << 2) |
                                             ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[i + 2] & 0x3F];

        // add line break
        if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0) {
            outputBytes[outputLength++] = '\r';
            outputBytes[outputLength++] = '\n';
        }
    }

    // handle left-over data
    if (i == inputLength - 2) { // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) |
                                             ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[(inputBytes[i + 1] & 0x0F) << 2];
        outputBytes[outputLength++] = '=';
    } else if (i == inputLength - 1) { // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }

    if (outputLength >= 4) {
        // truncate data to match actual output length
        outputBytes = realloc(outputBytes, outputLength);
        return [[NSString alloc] initWithBytesNoCopy:outputBytes
                                              length:outputLength
                                            encoding:NSASCIIStringEncoding
                                        freeWhenDone:YES];
    } else if (outputBytes) {
        free(outputBytes);
    }
    return nil;
}


@end
