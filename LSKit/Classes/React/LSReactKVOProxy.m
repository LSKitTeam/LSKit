//
//  LSReactKVOProxy.m
//  Pods
//
//  Created by Lyson on 2019/10/1.
//

#import "LSReactKVOProxy.h"
#import "LSReactSubscribe.h"
@interface LSReactKVOProxy ()

@property (nonatomic, strong) NSMapTable *subscribes;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation LSReactKVOProxy

+ (instancetype)shareInstance {
    static LSReactKVOProxy *instance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        instance = [[self alloc] init];
    });

    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _queue = dispatch_queue_create("com.lskit.lsreactkvoproxy",
                                       DISPATCH_QUEUE_SERIAL);
        _subscribes = [NSMapTable strongToWeakObjectsMapTable];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {

    NSValue *valueContext = [NSValue valueWithPointer:context];
    __block NSObject *trueObserver;

    dispatch_sync(self.queue, ^{
        trueObserver = [self.subscribes objectForKey:valueContext];
    });

    //将消息转发到对应的对象上
    if (trueObserver != nil) {
        [trueObserver observeValueForKeyPath:keyPath
                                    ofObject:object
                                      change:change
                                     context:context];
    }
}

/// 添加监听
/// @param observer 监听主体对象
/// @param context 上下文
- (void)addObserver:(__weak NSObject *)observer forContext:(void *)context {
    NSValue *valueContext = [NSValue valueWithPointer:context];
    dispatch_sync(self.queue, ^{
        [self.subscribes setObject:observer forKey:valueContext];
    });
}

/// 添加监听
/// @param observer 监听主体对象
/// @param context 上下文
/// @param topic topic
- (void)addObserver:(__weak NSObject *)observer
         forContext:(void *)context
              topic:(NSString *)topic {

    NSValue *valueContext = [NSValue valueWithPointer:context];

    NSString *topicKey =
        [NSString stringWithFormat:@"%@_topic_%@_topic", valueContext, topic];

    dispatch_sync(self.queue, ^{
        [self.subscribes setObject:observer forKey:topicKey];
    });
}

/// 移除监听
/// @param observer observer
/// @param context context
/// @param topic topic
- (void)removeObserver:(NSObject *)observer
            forContext:(void *)context
                 topic:(NSString *)topic {

    NSString *topicKey = [NSString stringWithFormat:@"_topic_%@_topic", topic];

    dispatch_sync(self.queue, ^{

        NSArray *array = [[self.subscribes keyEnumerator] allObjects];

        __block NSString *valueKey = nil;

        [array
            enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx,
                                         BOOL *_Nonnull stop) {

                if ([obj isKindOfClass:[NSString class]] &&
                    [obj hasSuffix:topicKey]) {
                    valueKey = obj;
                    *stop = YES;
                }

            }];

        if (valueKey) {
            [self.subscribes removeObjectForKey:valueKey];
        }

    });
}

/// 移除监听
/// @param observer 监听主体对象
/// @param context 上下文
- (void)removeObserver:(NSObject *)observer forContext:(void *)context {
    NSValue *valueContext = [NSValue valueWithPointer:context];
    dispatch_sync(self.queue, ^{
        [self.subscribes removeObjectForKey:valueContext];
    });
}

/// 发送订阅消息
/// @param value value
/// @param topic topic
- (void)sendValue:(id)value forKey:(NSString *)topic {

    NSString *topicKey = [NSString stringWithFormat:@"_topic_%@_topic", topic];

    dispatch_sync(self.queue, ^{

        __weak typeof(self) weakSelf = self;
        NSArray *array = [[self.subscribes keyEnumerator] allObjects];

        [array
            enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx,
                                         BOOL *_Nonnull stop) {

                if ([obj isKindOfClass:[NSString class]] &&
                    [obj hasSuffix:topicKey]) {

                    NSObject *observe = [weakSelf.subscribes objectForKey:obj];

                    NSMutableDictionary *change =
                        [NSMutableDictionary dictionaryWithCapacity:0];
                    [change setValue:value forKey:NSKeyValueChangeNewKey];

                    [observe observeValueForKeyPath:topicKey
                                           ofObject:observe
                                             change:change
                                            context:(__bridge void *) observe];
                }

            }];

    });
}

@end
