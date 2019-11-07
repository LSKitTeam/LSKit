//
//  YDOServiceProtocol.h
//  Pods
//
//  Created by Lyson on 2019/4/11.
//

#import <Foundation/Foundation.h>
#import "YDOPluginCommon.h"
NS_ASSUME_NONNULL_BEGIN

@protocol YDOServiceBaseProtocol <NSObject>

@optional
- (void)setServiceCallback:(YDOLrpcCallback)callback;

+ (instancetype)shareInstance;

@end

@protocol YDOServiceProtocol <NSObject,YDOServiceBaseProtocol>

@optional


-(void)response:(int)code data:(nullable id)data error:(nullable NSError*)error;

-(void)start;

-(void)close;

-(void)setObject:(id)value forKey:(id)key;

@end



NS_ASSUME_NONNULL_END
