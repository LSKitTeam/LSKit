//
//  YDOServiceManager.m
//  Pods
//
//  Created by Lyson on 2019/4/11.
//

#import "YDOServiceManager.h"
#import "YDOServiceProtocol.h"

@interface YDOServiceManager ()

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSLock *serviceLock;

/** 强引用service */
@property (nonatomic, strong) NSMutableDictionary *servicesCache;

/** 协议和实例(字符串) */
@property (nonatomic, strong) NSMutableDictionary *servicesInfo;

/** 保存所有初始化的对象(用于发送信息) */
@property (nonatomic, strong) NSPointerArray *allInstanceTarget;
@end

@implementation YDOServiceManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static YDOServiceManager *_instance;
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
    _allInstanceTarget = [NSPointerArray weakObjectsPointerArray];
}

- (void)registerDynamicService:(Protocol *)service impl:(Class)impl {
    NSString *implName = NSStringFromClass(impl);
    NSString *serviceName = NSStringFromProtocol(service);
    if (![impl conformsToProtocol:@protocol(YDOServiceBaseProtocol)]) {
        return;
    }

    [self.lock lock];
    [self.servicesInfo setValue:implName forKey:serviceName];
    [self.lock unlock];
}

/// 移除Service
/// @param serviceKey cacheKey serviceName + objKey
- (void)removeServiceByKey:(NSString *)serviceKey {
    [self.lock lock];

    __block NSString *removeKey = serviceKey;

    if (![self.servicesCache objectForKey:serviceKey]) {

        [self.servicesInfo
            enumerateKeysAndObjectsUsingBlock:^(
                NSString *_Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {

                if ([key hasSuffix:[NSString
                                       stringWithFormat:@"_%@", serviceKey]]) {
                    removeKey = [key copy];
                    *stop = YES;
                }
            }];
    }

    [self.servicesCache removeObjectForKey:removeKey];

    [self.lock unlock];
}

- (id)createService:(Protocol *)service {
    NSString *serviceName = NSStringFromProtocol(service);
    if (![self checkValidService:serviceName]) return nil;

    id implInstance;

    Class cls = [self serviceImplClass:serviceName];

    if ([cls conformsToProtocol:service]) {
        if ([cls respondsToSelector:@selector(shareInstance)]) {
            implInstance = [cls shareInstance];

        } else {
            implInstance = [[cls alloc] init];

            NSString *cacheKey =
                [NSString stringWithFormat:@"%@_%@", serviceName, implInstance];

            [self.serviceLock lock];
            [self.servicesCache setValue:implInstance forKey:cacheKey];
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
