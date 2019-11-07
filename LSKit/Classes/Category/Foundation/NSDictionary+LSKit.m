//
//  NSDictionary+LSKit.m
//  LSKit
//
//  Created by Lyson on 2019/9/14.
//

#import "NSDictionary+LSKit.h"

@implementation NSDictionary (LSKit)


/**
 排序所有key

 @return 排序后的Array
 */
- (NSArray *)ls_allKeysSorted {
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

/**
 是否包含某个字

 @param key key
 @return YES NO
 */
- (BOOL)ls_containsObjectForKey:(id)key {
    if (!key) return NO;
    return self[key] != nil;
}

/**
 json序列化

 @return json字符串
 */
- (NSString *)ls_jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

- (NSString *)description {
    if (self.allKeys.count > 0) {
        NSMutableString *string = [NSMutableString string];
        [string appendString:@"{\n"];
        [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [string appendFormat:@"\t%@", key];
            [string appendString:@" : "];
            [string appendFormat:@"%@,\n", obj];
        }];
        [string appendString:@"}"];
        NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
        if (range.location != NSNotFound) [string deleteCharactersInRange:range];
        return string;
    }
    return nil;
}

@end
