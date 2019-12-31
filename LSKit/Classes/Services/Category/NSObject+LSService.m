//
//  NSObject+LSNetworkRequest.m
//  LSKit
//
//  Created by Lyson on 2019/9/29.
//

#import "NSObject+LSService.h"
#import "LSServiceManager.h"
#import "LSModuleManager.h"
#import <objc/runtime.h>
#import "LSServiceProtocol.h"

@implementation NSObject (LSService)

static const char servicesArray;

#pragma mark -设置环境存储请求

- (void)setServicesArray:(NSHashTable *)services {
    objc_setAssociatedObject(self, &servicesArray, services,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSHashTable *)servicesArray {
    NSHashTable *nets = objc_getAssociatedObject(self, &servicesArray);
    return nets;
}

/// 派发事件
/// @param event event
/// @param data data
- (void)triggerCustomModule:(NSString *)event data:(NSDictionary *)data {
    [[LSModuleManager shareInstance] triggerCustomModule:event data:data];
}

/// 创建一个service
/// @param protocol protocol
- (__weak id<LSServiceProtocol>)ls_CreateService:(Protocol *)protocol {
    id service = [[LSServiceManager shareInstance] createService:protocol];
    if (!self.servicesArray) {
        self.servicesArray = [NSHashTable weakObjectsHashTable];
    }
    [self.servicesArray addObject:service];
    return service;
}

- (id<LSServiceProtocol>)ls_subscribeNext:(void (^)(id value))next {
    if ([(LSService *)self respondsToSelector:@selector(setCallbackNext:)]) {
        [(LSService *)self setCallbackNext:next];
    }
    return (id<LSServiceProtocol>)self;
}

- (id<LSServiceProtocol>)ls_subscribeSuccess:(void (^)(id responseObject))success {
    if ([(LSService *)self respondsToSelector:@selector(setCallbackSuccess:)]) {
        [(LSService *)self setCallbackSuccess:success];
    }
    return (id<LSServiceProtocol>)self;
}

- (id<LSServiceProtocol>)ls_subscribeFailure:(void (^)(NSError *error))failure {
    if ([(LSService *)self respondsToSelector:@selector(setCallbackFailure:)]) {
        [(LSService *)self setCallbackFailure:failure];
    }
    return (id<LSServiceProtocol>)self;
}

/// 取消请求
- (void)ls_cancelService:(id)service {
    if ([((id<LSServiceProtocol>)service) respondsToSelector:@selector(releaseService)]) {
        [((id<LSServiceProtocol>)service) releaseService];
    }
    [[LSServiceManager shareInstance] removeService:service];
}

/// 取消请求
- (void)ls_cancelAllServices {
    NSArray *tasks = [self.servicesArray allObjects];
    [tasks enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx,
                                        BOOL *_Nonnull stop) {
        if ([((id<LSServiceProtocol>)obj) respondsToSelector:@selector(releaseService)]) {
            [((id<LSServiceProtocol>)obj) releaseService];
        }
        [[LSServiceManager shareInstance] removeService:obj];
    }];
}

#pragma mark -替换方法
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel = NSSelectorFromString(@"dealloc");
        Method originalMethod = class_getInstanceMethod(self, sel);
        Method swizzledMethod =
            class_getInstanceMethod(self, @selector(ls_Servicedealloc));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)ls_Servicedealloc {
    if (self.servicesArray || [self.servicesArray allObjects] > 0) {
        [self ls_cancelAllServices];
    }
    [self ls_Servicedealloc];
}

@end
