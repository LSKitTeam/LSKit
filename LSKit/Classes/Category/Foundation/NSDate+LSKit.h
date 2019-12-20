//
//  NSDate+LSKit.h
//  Pods
//
//  Created by Lyson on 2019/11/27.
//

#import <Foundation/Foundation.h>

@interface NSDate (LSKit)

/// 获取当前格式化的时间
+ (NSString *)ls_nowFormatterTime;

/// 格式化时间戳
/// @param timestamp timestamp
/// @param format format
+ (NSString *)ls_timeFormatter:(NSString *)timestamp format:(NSString *)format;

/// 格式化时间
/// @param timeStamp timestamp
/// @param format format
/// @param timeZone timeZone
+ (NSString *)ls_formater:(NSInteger)timeStamp format:(NSString *)format timeZone:(NSInteger)timeZone;

/// 格式化时间转时间戳
/// @param time time
/// @param format format
- (NSInteger)ls_timeStamp:(NSString *)time format:(NSString *)format;

/// 获取毫秒级时间戳
- (NSInteger)ls_millTimestamp;
@end
