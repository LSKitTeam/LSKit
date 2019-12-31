//
//  YDOServiceManager.h
//  Pods
//
//  Created by Lyson on 2019/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LSServiceProtocol;

/**
 服务管理
 */
@interface LSServiceManager : NSObject

+ (instancetype)shareInstance;

/**
 注册服务
 @param service 服务名
 @param impl 服务对应的实现文件
 */
- (void)registerDynamicService:(Protocol *)service impl:(Class)impl;

/** 创建一个服务实例(强引用) */
- (id)createService:(Protocol *)service;

/**
 创建一个实例
 @param service 服务
 @param shouldCache 是否存储
 @return 服务实体
 */
- (id)createService:(Protocol *)service shouldCache:(BOOL)shouldCache;

/// 移除Service
/// @param implInstance implinstance 协议实现的实例
/// @param protocol protocol 协议
- (void)removeService:(id)implInstance protocol:(Protocol *)protocol;

/// 移除dservice
/// @param implInstance service对象
- (void)removeService:(id)implInstance;
@end

NS_ASSUME_NONNULL_END
