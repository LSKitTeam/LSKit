//
//  YDOServiceProtocol.h
//  Pods
//
//  Created by Lyson on 2019/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LSServiceProtocol <NSObject>

@optional

+ (instancetype)shareInstance;

/// 取消请求
- (void)releaseService;

- (__kindof id<LSServiceProtocol>)ls_subscribeNext:(void (^)(id value))next;

- (__kindof id<LSServiceProtocol>)ls_subscribeSuccess:(void (^)(id responseObject))success;

- (__kindof id<LSServiceProtocol>)ls_subscribeFailure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
