//
//  NSDate+LSKit.m
//  Pods
//
//  Created by Lyson on 2019/11/27.
//

#import "NSDate+LSKit.h"

@implementation NSDate (LSKit)

/// 获取毫秒级时间戳
/// @param datetime NSDate
+ (long long)ls_millTimestamp:(NSDate *)datetime {
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    long long timestamp = interval * 1000;
    return timestamp;
}

/// 获取当前时间-毫秒
+ (long long)ls_nowTimestamp {
    long long timestamp = [self ls_millTimestamp:[NSDate date]];
    return timestamp;
}

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

@end
