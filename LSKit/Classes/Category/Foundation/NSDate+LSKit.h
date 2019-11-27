//
//  NSDate+LSKit.h
//  Pods
//
//  Created by Lyson on 2019/11/27.
//

#import <Foundation/Foundation.h>

@interface NSDate (LSKit)

/// 获取毫秒级时间戳
/// @param datetime NSDate
+ (long long)ls_millTimestamp:(NSDate *)datetime;

/// 获取当前时间-毫秒
+ (long long)ls_nowTimestamp;

/// 获取当前格式化的时间
+ (NSString *)ls_nowFormatterTime;

/// 格式化时间戳
/// @param timestamp timestamp
/// @param format format
+ (NSString *)ls_timeFormatter:(NSString *)timestamp format:(NSString *)format;

@end
