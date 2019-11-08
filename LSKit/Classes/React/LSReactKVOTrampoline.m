//
//  LSReactKVOTrampoline.m
//  Pods
//
//  Created by Lyson on 2019/10/4.
//

#import "LSReactKVOTrampoline.h"
#import "LSReactKVOProxy.h"
@interface LSReactKVOTrampoline ()
@property (nonatomic, weak) LSReactSubscribe *subscribe;
@property (nonatomic, weak) NSObject *weakTarget;
@property (nonatomic, copy) NSString *keyPath;

@end

@implementation LSReactKVOTrampoline

/// 初始化
/// @param subscribe subscribe
/// @param weakTarget weakTarget
/// @param keypath keypath
//  @param isGlobal 话题订阅 全局的
- (instancetype)initWithSubscribe:(LSReactSubscribe *)subscribe
                    observeTarget:(__weak id)weakTarget
                          keypath:(NSString *)keypath
                          isGlobal:(BOOL)isGlobal {
    if (self = [super init]) {

        self.subscribe = subscribe;
        self.weakTarget = weakTarget;
        self.keyPath = keypath;
        _isGlobal = isGlobal;

        NSObject *strongTarget = weakTarget;

        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew |
                                             NSKeyValueObservingOptionOld |
                                             NSKeyValueObservingOptionInitial;

        if (strongTarget && !isGlobal) {

            [LSReactKVOProxy.shareInstance addObserver:self
                                            forContext:(__bridge void *) self];
            [strongTarget addObserver:LSReactKVOProxy.shareInstance
                           forKeyPath:self.keyPath
                              options:options
                              context:(__bridge void *) self];
        } else {
            [LSReactKVOProxy.shareInstance addObserver:self
                                            forContext:(__bridge void *) self
                                                 globalKeyPath:self.keyPath];
        }
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
    if (context != (__bridge void *) self) {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
        return;
    }

    id changeValue = [change objectForKey:NSKeyValueChangeNewKey];
    if (self.subscribe) {
        [self.subscribe sendValue:changeValue];
    }
}

- (void)dealloc {
    NSLog(@"释放了 %@", self.description);
}
@end
