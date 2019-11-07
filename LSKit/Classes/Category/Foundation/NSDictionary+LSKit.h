//
//  NSDictionary+LSKit.h
//  LSKit
//
//  Created by Lyson on 2019/9/14.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (LSKit)

/**
 排序所有key
 
 @return 排序后的Array
 */
- (NSArray *)ls_allKeysSorted;

/**
 是否包含某个字
 
 @param key key
 @return YES NO
 */
- (BOOL)ls_containsObjectForKey:(id)key;

/**
 json序列化
 
 @return json字符串
 */
- (NSString *)ls_jsonStringEncoded;

@end
