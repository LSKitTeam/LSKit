//
//  NSObject+LSRpc.m
//  Pods
//
//  Created by Lyson on 2019/11/1.
//

#import "NSObject+LSRpc.h"
#import <objc/runtime.h>
#import "YDOServiceProtocol.h"

static const char __rpcCacheDictionary;

@implementation NSObject (LSRpc)

#pragma mark -设置环境存储请求

- (void)setRpcCacheDictionary:(NSMutableDictionary *)rpcCacheDictionary {

    objc_setAssociatedObject(self, &__rpcCacheDictionary, rpcCacheDictionary,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)rpcCacheDictionary {
    NSMutableDictionary *rpcDic =
        objc_getAssociatedObject(self, &__rpcCacheDictionary);
    return rpcDic;
}

#pragma mark -替换方法
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel = NSSelectorFromString(@"dealloc");
        Method originalMethod = class_getInstanceMethod(self, sel);
        Method swizzledMethod =
            class_getInstanceMethod(self, @selector(ls_rpcdealloc));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)ls_rpcdealloc {

    [self ls_rpcdealloc];
}

- (id)ls_createService:(Protocol *)service
              callback:(YDOLrpcCallback)rpcCallback {

    id<YDOServiceBaseProtocol> serviceObj = [YDOLrpc createService:service];
    [serviceObj setServiceCallback:^BOOL(int code, id data, NSError *error) {
        return YES;
    }];
    
    return serviceObj;
}

@end


