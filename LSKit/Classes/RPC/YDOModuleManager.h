//
//  YDOModuleManager.h
//  Pods
//
//  Created by Lyson on 2019/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Router 组件管理  ---
 */
@interface YDOModuleManager : NSObject

+ (instancetype)shareInstance;

/**
 注册组件

 @param cls 需要注册的类
 */
- (void)registerDynamicModule:(Class)cls;

/**
 派发数据

 @param event 事件
 @param data 数据
 */
- (void)triggerCustomModule:(NSString *)event data:(NSDictionary *)data;

- (void)triggerApplication:(UIApplication *)application
           didFinishLaunch:(NSDictionary *)launchOption;
@end

NS_ASSUME_NONNULL_END
