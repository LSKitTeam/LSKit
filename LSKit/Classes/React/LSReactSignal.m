//
//  LSReactSignal.m
//  Pods
//
//  Created by Lyson on 2019/10/2.
//

#import "LSReactSignal.h"
#import "LSReactSubscribe.h"
#import "LSReactDispose.h"
#import "LSReactKVOTrampoline.h"

//@interface LSReactSignalHandler ()
//
//@property (nonatomic, strong) NSMutableArray *signals;
//@property (nonatomic, strong) NSLock *lock;
//
//@end
//
//@implementation LSReactSignalHandler
//
//+ (instancetype)shareInstance {
//
//    static LSReactSignalHandler *_instance;
//    static dispatch_once_t onceToken;
//
//    dispatch_once(&onceToken, ^{
//        _instance = [[self alloc] init];
//    });
//
//    return _instance;
//}
//
//- (instancetype)init {
//    if (self = [super init]) {
//        _signals = [NSMutableArray arrayWithCapacity:0];
//        _lock = [NSLock new];
//    }
//    return self;
//}
//
///// 添加信号
///// @param signal signal
//- (void)addSignal:(LSReactSignal *)signal {
//    [self.lock lock];
//    [self.signals addObject:signal];
//    [self.lock unlock];
//}
//
///// 移除信号
///// @param signal signal
//- (void)removeSignal:(LSReactSignal *)signal {
//    [signal.dispose dispose];
//    [self.lock lock];
//    [self.signals removeObject:signal];
//    [self.lock unlock];
//}
//
///// 移除所有信号
//- (void)removeAllSignal {
//    [self.lock lock];
//    NSMutableArray *array = [self.signals mutableCopy];
//    [self.signals removeAllObjects];
//    [self.lock unlock];
//
//    for (LSReactSignal *signal in array) {
//        [signal dispose];
//    }
//    [array removeAllObjects];
//}
//
//@end

@interface LSReactSignal ()
@property (nonatomic, strong) LSReactSubscribe *subscribeObj;
@property (nonatomic, strong) LSReactKVOTrampoline *trampoline;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, weak) NSObject *observe;
@property (nonatomic, assign) BOOL isTopic;
@property (nonatomic, copy) BOOL (^mapBlock)(id value);
@property (nonatomic, assign) NSInteger skipCount;
@property (nonatomic, assign) NSInteger sendCount;
@end

@implementation LSReactSignal

+ (LSReactSignal *)createSignalWithKeyPath:(NSString *)keypath
                                   observe:(__weak NSObject *)observe {

    LSReactSignal *signal = [LSReactSignal new];
    signal.observe = observe;
    signal.keyPath = keypath;
    signal.isTopic = NO;
    return signal;
}

+ (LSReactSignal *)createSignalWithTopic:(NSString *)keypath
                                 observe:(__weak NSObject *)observe {

    LSReactSignal *signal = [LSReactSignal new];
    signal.observe = observe;
    signal.keyPath = keypath;
    signal.isTopic = YES;
    return signal;
}

- (instancetype)init {
    if (self = [super init]) {

        [self initDispose];
    }
    return self;
}

- (void)initDispose {
    self.dispose = [[LSReactDispose alloc] init];
    self.dispose.signal = self;
}

- (void)initTrampoline {

    LSReactKVOTrampoline *poline =
        [[LSReactKVOTrampoline alloc] initWithSubscribe:self.subscribeObj
                                          observeTarget:self.observe
                                                keypath:self.keyPath
                                                isTopic:self.isTopic];
    self.trampoline = poline;
}

/// 订阅数据
/// @param subscribe subscribe
- (LSReactDispose *)subscribe:(void (^)(id value))subscribe {

    __weak typeof(self) weakSelf = self;
    LSReactSubscribe *subScribeObj =
        [[LSReactSubscribe alloc] initWithBlock:^(id value) {
            weakSelf.sendCount++;
            if (weakSelf.sendCount <= weakSelf.skipCount) {
                return;
            }
            if (weakSelf.mapBlock && !weakSelf.mapBlock(value)) {
                return;
            }

            subscribe(value);
        }];
    self.subscribeObj = subScribeObj;
    [self initTrampoline];

    return self.dispose;
}

- (LSReactSignal *)skip:(NSInteger)skip {

    self.skipCount = skip;

    return self;
}

- (LSReactSignal *)map:(BOOL (^)(id value))map {
    self.mapBlock = map;
    return self;
}

- (void)dealloc {
    NSLog(@"释放了 %@", self.description);
}
@end
