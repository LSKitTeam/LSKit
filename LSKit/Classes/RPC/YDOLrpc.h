//
//  YDOLrpc.h
//  Pods
//
//  Created by Lyson on 2019/4/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YDOPluginCommon.h"

NS_ASSUME_NONNULL_BEGIN




/**
 本地服务调用
 */
@interface YDOLrpc : NSObject

/// 移除Service
/// @param serviceObj service对象
- (void)removeServiceByService:(id)serviceObj;

/// 移除Service
/// @param serviceKey cacheKey serviceName + objKey
- (void)removeServiceByKey:(NSString *)serviceKey;

/**
 创建一个服务实例

 @param service 服务名
 @return 服务实例
 */
+(id)createService:(Protocol*)service;

/**
 注册服务

 @param service 服务
 @param impl 服务对应的实现地址
 */
+(void)registerDynamicService:(Protocol*)service impl:(Class)impl;

/**
 注册组件

 @param cls 组件类
 */
+(void)registerDynamicModule:(Class)cls;

/**
 派发事件 --组件间派发 module 2 module

 @param event  定义的事件
 @param data 数据
 */
+(void)triggerCustomModule:(NSString*)event data:(NSDictionary*)data;

+(void)triggerApplication:(UIApplication*)application didFinishLaunch:(NSDictionary*)launchOption;

@end

NS_ASSUME_NONNULL_END
