//
//  NSObject+LSReactSignal.m
//  Pods
//
//  Created by Lyson on 2019/10/7.
//

#import "NSObject+LSReactSignal.h"
#import <objc/runtime.h>
#import "LSReactSignal.h"
#import "LSReactKVOProxy.h"

static const char signalArray;

@interface NSObject (LSReactSignalArray)
@property (nonatomic, assign) NSMutableArray *signalsArray;
@end

@implementation NSObject (LSReactSignalArray)

#pragma mark -设置环境存储请求

- (void)setSignalsArray:(NSMutableArray *)signalsArray {
    objc_setAssociatedObject(self, &signalArray, signalsArray,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)signalsArray {
    NSMutableArray *signals = objc_getAssociatedObject(self, &signalArray);
    return signals;
}

#pragma mark -替换方法
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel = NSSelectorFromString(@"dealloc");
        Method originalMethod = class_getInstanceMethod(self, sel);
        Method swizzledMethod =
            class_getInstanceMethod(self, @selector(ls_signaldealloc));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)disposeSignals {

    if (self.signalsArray || [self.signalsArray count] > 0) {

        for (LSReactSignal *signal in self.signalsArray) {
            [signal dispose];
        }
        [self.signalsArray removeAllObjects];
    }
}

- (void)ls_signaldealloc {

//    [self disposeSignals];

    [self ls_signaldealloc];
}

@end

@implementation NSObject (LSReactSignal)

- (LSReactSignal *)ls_valuesForKeyPath:(NSString *)keyPath{

    LSReactSignal *signal =
        [LSReactSignal createSignalWithKeyPath:keyPath observe:self];

    NSMutableArray *signals = self.signalsArray;
    if (!signals) {
        signals = [NSMutableArray arrayWithCapacity:0];
    }

    [signals addObject:signal];

    self.signalsArray = signals;
    
    return signal;
}

- (LSReactSignal *)ls_valuesForGlobalKeyPath:(NSString *)keyPath{

    LSReactSignal *signal =
        [LSReactSignal createSignalWithGlobalKeyPath:keyPath observe:self];

    NSMutableArray *signals = self.signalsArray;
    if (!signals) {
        signals = [NSMutableArray arrayWithCapacity:0];
    }

    [signals addObject:signal];

    self.signalsArray = signals;
    
    return signal;
}

-(void)ls_sendSignal:(NSString*)keyPath values:(id)values{

    [[LSReactKVOProxy shareInstance] sendValue:values forKey:keyPath];
}

//遍历获取Person类所有的成员变量IvarList
- (void) getAllIvarList {
    unsigned int methodCount = 0;
    Ivar * ivars = class_copyIvarList([self class], &methodCount);
    for (unsigned int i = 0; i < methodCount; i ++) {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
        
        NSLog(@"----:%s",name);
    }
    free(ivars);
}

@end
