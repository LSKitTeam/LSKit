//
//  NSObject+LSReactSignal.h
//  Pods
//
//  Created by Lyson on 2019/10/7.
//

#import <Foundation/Foundation.h>

@class LSReactSignal;

@interface NSObject (LSReactSignal)


/// object kvo 监听
/// @param keyPath 监听对象
- (LSReactSignal *)ls_valuesForKeyPath:(NSString *)keyPath;

/// object 订阅话题
/// @param keyPath keypath
- (LSReactSignal *)ls_valuesForTopic:(NSString *)keyPath;

/// 发送订阅话题
/// @param keyPath 话题
/// @param values 数据
- (void)ls_sendSignal:(NSString *)keyPath values:(id)values;

@end
