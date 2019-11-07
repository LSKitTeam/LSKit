//
//  LSReactKVOProxy.h
//  Pods
//
//  Created by Lyson on 2019/10/1.
//

#import <Foundation/Foundation.h>

@interface LSReactKVOProxy : NSObject

+ (instancetype)shareInstance;

/// 发送订阅消息
/// @param value value
/// @param topic topic
- (void)sendValue:(id)value forKey:(NSString *)topic;

/// 添加监听
/// @param observer 监听主体对象
/// @param context 上下文
- (void)addObserver:(__weak NSObject *)observer forContext:(void *)context;

/// 添加监听
/// @param observer 监听主体对象
/// @param context 上下文
/// @param topic topic
- (void)addObserver:(__weak NSObject *)observer forContext:(void *)context topic:(NSString*)topic;

/// 移除监听
/// @param observer 监听主体对象
/// @param context 上下文
- (void)removeObserver:(NSObject *)observer forContext:(void *)context;

/// 移除监听
/// @param observer observer
/// @param context context
/// @param topic topic
- (void)removeObserver:(NSObject *)observer
            forContext:(void *)context
                 topic:(NSString *)topic;

@end
