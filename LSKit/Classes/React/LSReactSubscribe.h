//
//  LSReactSubscribe.h
//  Pods
//
//  Created by Lyson on 2019/10/2.
//

#import <Foundation/Foundation.h>

@interface LSReactSubscribe : NSObject

/// 初始化
/// @param subscribe subscribe
- (instancetype)initWithBlock:(void (^)(id value))subscribe;

/// 发送订阅数据
/// @param value 订阅数据
- (void)sendValue:(id)value;

@end
