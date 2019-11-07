//
//  NSError+LSKit.m
//  Pods
//
//  Created by Lyson on 2019/9/12.
//

#import "NSError+LSKit.h"

@implementation NSError (LSKit)

/**
 错误

 @param domain 错误域
 @param code 错误码
 @param infos 错误信息
 @return NSError对象
 */
+ (NSError *)ls_error:(NSString *)domain code:(NSInteger)code infos:(id)infos {

    NSError *error = [NSError errorWithDomain:domain code:code userInfo:infos];

    return error;
}

/**
 获取错误信息

 @param errorKey 需要获取的key值，主要是从error的userinfo里获取
 @return 返回提示语
 */
- (NSString *)ls_errorMsg:(NSString *)errorKey {

    NSString *errorMsg = nil;

    if (errorKey.length > 0) {
        errorMsg = self.userInfo[errorKey];
    }

    if (!errorMsg || errorMsg.length <= 0) {
        errorMsg = self.userInfo[NSLocalizedDescriptionKey];
    }
    return errorMsg;
}


/**
 获取errorMsg 系统默认 NSLocalizedDescriptionKey

 @return NSLocalizedDescriptionKey错误信息
 */
-(NSString*)ls_errorMsg{
    
    NSString *errorMsg = nil;

    if (!errorMsg || errorMsg.length <= 0) {
        errorMsg = self.userInfo[NSLocalizedDescriptionKey];
    }
    return errorMsg;
}


/**
 错误原因

 @return NSLocalizedFailureReasonErrorKey原因
 */
-(NSString*)ls_errorReason{
    
    NSString *errorReason = nil;
    
    if (!errorReason || errorReason.length <= 0) {
        errorReason = self.userInfo[NSLocalizedFailureReasonErrorKey];
    }
    return errorReason;
}

@end
