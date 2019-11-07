//
//  LSReactSubscribe.m
//  Pods
//
//  Created by Lyson on 2019/10/2.
//

#import "LSReactSubscribe.h"

@interface LSReactSubscribe ()
@property (nonatomic, copy) void (^subscribeValueBlock)(id value);
@end

@implementation LSReactSubscribe

/// 初始化
/// @param subscribe subscribe
- (instancetype)initWithBlock:(void (^)(id value))subscribe{
    if (self = [super init]) {
        self.subscribeValueBlock = subscribe;
    }
    return self;
}

/// 发送订阅数据
/// @param value 订阅数据
- (void)sendValue:(id)value {

    @synchronized(self) {
        void (^subscribeValueBlock)(id) = [self.subscribeValueBlock copy];
        if (subscribeValueBlock == nil) return;
        subscribeValueBlock(value);
    }
}

- (void)dealloc {
    NSLog(@"释放了 %@", self.description);
}
@end
