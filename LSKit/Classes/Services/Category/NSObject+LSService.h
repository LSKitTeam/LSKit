//
//  NSObject+LSNetworkRequest.h
//  LSKit
//
//  Created by Lyson on 2019/9/29.
//

#import <Foundation/Foundation.h>
#import "LSService.h"
#import "LSAnnotation.h"

@protocol LSServiceProtocol;

@interface NSObject (LSService)

@property (nonatomic, copy) NSHashTable *_Nullable servicesArray;

/// 创建一个service
/// @param protocol protocol
- (__kindof __weak id<LSServiceProtocol> _Nullable)ls_CreateService:(Protocol *_Nullable)protocol;

/// 取消service
- (void)ls_cancelService:(id _Nullable)service;

/// 派发事件
/// @param event event
/// @param data data
- (void)triggerCustomModule:(NSString *)event data:(NSDictionary *)data;
@end
