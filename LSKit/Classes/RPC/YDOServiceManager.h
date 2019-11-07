//
//  YDOServiceManager.h
//  Pods
//
//  Created by Lyson on 2019/4/11.
//

#import <Foundation/Foundation.h>

#import "YDOPluginCommon.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YDOServiceProtocol;

/**
 服务管理
 */
@interface YDOServiceManager : NSObject

+ (instancetype)shareInstance;

/**
 注册服务
 @param service 服务名
 @param impl 服务对应的实现文件
 */
- (void)registerDynamicService:(Protocol *)service impl:(Class)impl;

/// 移除Service
/// @param serviceKey cacheKey serviceName + objKey
- (void)removeServiceByKey:(NSString *)serviceKey;

/** 创建一个服务实例(强引用) */
- (id)createService:(Protocol *)service;

@end

NS_ASSUME_NONNULL_END
