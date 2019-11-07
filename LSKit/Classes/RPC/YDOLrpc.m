//
//  YDOLrpc.m
//  Pods
//
//  Created by Lyson on 2019/4/11.
//

#import "YDOLrpc.h"
#import "YDOServiceManager.h"
#import "YDOModuleManager.h"

@implementation YDOLrpc

+ (id)createService:(Protocol *)service {
    return [[YDOServiceManager shareInstance] createService:service];
}

/// 移除Service
/// @param serviceObj service对象
- (void)removeServiceByService:(id)serviceObj {

    NSString *serviceKey = [NSString stringWithFormat:@"%@", serviceObj];
    [[YDOServiceManager shareInstance] removeServiceByKey:serviceKey];
}

/// 移除Service
/// @param serviceKey cacheKey serviceName + objKey
- (void)removeServiceByKey:(NSString *)serviceKey {
    [[YDOServiceManager shareInstance] removeServiceByKey:serviceKey];
}

+ (void)registerDynamicService:(Protocol *)service impl:(Class)impl {

    NSString *cls = NSStringFromClass(impl);
    NSString *protocol = NSStringFromProtocol(service);

    if (cls.length > 0 && protocol.length > 0) {
        [[YDOServiceManager shareInstance] registerDynamicService:service
                                                             impl:impl];
    }
}

+ (void)registerDynamicModule:(Class)cls {

    NSString *clsString = NSStringFromClass(cls);

    if (clsString.length > 0) {
        [[YDOModuleManager shareInstance] registerDynamicModule:cls];
    }
}

+ (void)triggerCustomModule:(NSString *)event data:(NSDictionary *)data {

    [[YDOModuleManager shareInstance] triggerCustomModule:event data:data];
}

+ (void)triggerApplication:(UIApplication *)application
           didFinishLaunch:(NSDictionary *)launchOption {

    [[YDOModuleManager shareInstance] triggerApplication:application
                                         didFinishLaunch:launchOption];
}
@end
