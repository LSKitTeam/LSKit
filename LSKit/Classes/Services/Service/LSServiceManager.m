//
//  YDOServiceManager.m
//  Pods
//
//  Created by Lyson on 2019/4/11.
//

#import "LSServiceManager.h"
#import "LSServiceProtocol.h"

@interface LSServiceManager ()

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSLock *serviceLock;

/** 强引用service */
@property (nonatomic, strong) NSMutableDictionary *servicesCache;

/** 协议和实例(字符串) */
@property (nonatomic, strong) NSMutableDictionary *servicesInfo;

@end

@implementation LSServiceManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static LSServiceManager *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) [self initData];
    return self;
}

- (void)initData {
    _lock = [[NSLock alloc] init];
    _serviceLock = [[NSLock alloc] init];
    _servicesInfo = [NSMutableDictionary dictionary];
    _servicesCache = [NSMutableDictionary dictionary];
}

- (void)registerDynamicService:(Protocol *)service impl:(Class)impl {
    NSString *implName = NSStringFromClass(impl);
    NSString *serviceName = NSStringFromProtocol(service);
    if (![impl conformsToProtocol:@protocol(LSServiceProtocol)]) {
        return;
    }

    [self.lock lock];
    [self.servicesInfo setValue:implName forKey:serviceName];
    [self.lock unlock];
}

/// 移除Service
/// @param implInstance implinstance 协议实现的实例
/// @param protocol protocol 协议
- (void)removeService:(id)implInstance protocol:(Protocol *)protocol {
    NSString *serviceName = NSStringFromProtocol(protocol);
    NSString *serviceKey = [NSString stringWithFormat:@"%@_%@", serviceName, implInstance];
    [self.serviceLock lock];
    [self.servicesCache removeObjectForKey:serviceKey];
    [self.serviceLock unlock];
}

/// 移除dservice
/// @param implInstance service对象
- (void)removeService:(id)implInstance {
    __block NSString *removeKey = nil;

    [self.servicesCache enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        if (obj == implInstance) {
            removeKey = key;
            *stop = YES;
        }
    }];
    [self.serviceLock lock];
    [self.servicesCache removeObjectForKey:removeKey];
    [self.serviceLock unlock];
}

/** 创建一个服务实例 */
- (id)createService:(Protocol *)service {
    return [self createService:service shouldCache:YES];
}

- (id)createService:(Protocol *)service shouldCache:(BOOL)shouldCache {
    NSString *serviceName = NSStringFromProtocol(service);
    if (![self checkValidService:serviceName]) return nil;

    id implInstance = nil;

    Class cls = [self serviceImplClass:serviceName];
    if ([cls conformsToProtocol:service]) {
        if ([cls respondsToSelector:@selector(shareInstance)]) {
            implInstance = [cls shareInstance];
            shouldCache = NO;
        } else {
            implInstance = [[cls alloc] init];
        }

        if (shouldCache) {
            NSString *serviceKey = [NSString stringWithFormat:@"%@_%@", serviceName, implInstance];
            [self.serviceLock lock];
            [self.servicesCache setValue:implInstance forKey:serviceKey];
            [self.serviceLock unlock];
        }
    }
    return implInstance;
}

- (Class)serviceImplClass:(NSString *)serviceName {
    NSString *serviceImpl = [[self serviceInfoDict] objectForKey:serviceName];
    if (serviceImpl.length > 0) {
        return NSClassFromString(serviceImpl);
    }
    return nil;
}

- (BOOL)checkValidService:(NSString *)serviceName {
    NSString *impl = [[self serviceInfoDict] objectForKey:serviceName];
    if (impl) return YES;
    return NO;
}

- (NSDictionary *)serviceInfoDict {
    [self.lock lock];
    NSDictionary *dict = [self.servicesInfo copy];
    [self.lock unlock];
    return dict;
}

@end
