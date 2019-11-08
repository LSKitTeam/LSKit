//
//  LSReactSignal.h
//  Pods
//
//  Created by Lyson on 2019/10/2.
//

#import <Foundation/Foundation.h>
#import "LSReactSubscribe.h"

@class LSReactDispose;

@interface LSReactSignal : NSObject

@property (nonatomic, strong) LSReactDispose *dispose;

+ (LSReactSignal *)createSignalWithKeyPath:(NSString *)keypath
                                   observe:(__weak NSObject *)observe;

+ (LSReactSignal *)createSignalWithGlobalKeyPath:(NSString *)keypath
                                 observe:(__weak NSObject *)observe;
/// 订阅数据
/// @param subscribe subscribe
- (LSReactDispose *)subscribe:(void (^)(id value))subscribe;

//跳过次数
-(LSReactSignal*)skip:(NSInteger)skip;

/// 过滤
/// @param map 过滤规则
- (LSReactSignal *)map:(BOOL (^)(id value))map;
@end

//@interface LSReactSignalHandler : NSObject
//
//+ (instancetype)shareInstance;
//
///// 移除所有信号
//- (void)removeAllSignal;
//
///// 移除信号
///// @param signal signal
//- (void)removeSignal:(LSReactSignal *)signal;
//
///// 添加信号
///// @param signal signal
//- (void)addSignal:(LSReactSignal *)signal;
//
//@end
