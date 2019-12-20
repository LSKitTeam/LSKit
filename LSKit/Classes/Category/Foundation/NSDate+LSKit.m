//
//  NSDate+LSKit.m
//  Pods
//
//  Created by Lyson on 2019/11/27.
//

#import "NSDate+LSKit.h"

@implementation NSDate (LSKit)

/// 获取当前格式化的时间
+ (NSString *)ls_nowFormatterTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
    NSDate *datenow = [NSDate date];
    NSString *time = [formatter stringFromDate:datenow];

    return time;
}

/// 格式化时间戳
/// @param timestamp timestamp
/// @param format format
+ (NSString *)ls_timeFormatter:(NSString *)timestamp format:(NSString *)format {
    NSString *timeString =
        [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];

    if (timeString.length >= 10) {
        NSString *second = [timeString substringToIndex:10];
        NSString *milliscond = [timeString substringFromIndex:10];
        NSString *timeStampString =
            [NSString stringWithFormat:@"%@.%@", second, milliscond];
        NSTimeInterval _interval = [timeStampString doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        NSString *dateString = [dateFormatter stringFromDate:date];

        return dateString;
    }
    return @"";
}

/// 格式化时间
/// @param timeStamp timestamp
/// @param format format
/// @param timeZone timeZone
+ (NSString *)ls_formater:(NSInteger)timeStamp format:(NSString *)format timeZone:(NSInteger)timeZone {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSTimeZone *zone = [NSTimeZone timeZoneForSecondsFromGMT:timeZone];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:format];
    NSString *time = [formatter stringFromDate:date];

    return time;
}

/// 格式化时间转时间戳
/// @param time time
/// @param format format
- (NSInteger)ls_timeStamp:(NSString *)time format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:time];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];

    return timeInterval * 1000;
}

/// 获取毫秒级时间戳
- (NSInteger)ls_millTimestamp {
    NSTimeInterval interval = [self timeIntervalSince1970];
    long long timestamp = interval * 1000;
    return timestamp;
}

@end
