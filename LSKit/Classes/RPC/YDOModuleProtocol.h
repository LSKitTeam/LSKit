//
//  FDModuleProtocol.h
//  Pods
//
//  Created by Lyson on 2019/4/11.
//
#import "YDOContext.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol YDOModuleProtocol <NSObject>
@optional

/**
 通知组件已注册
 */
-(void)ydoModuleDidRegister;


/**
 自定义消息 格式为:module:action

 @param context 消息上下文
 */
-(void)moduleCustomEvent:(YDOContext*)context;

-(void)moduleApplicationFinishLaunch:(YDOContext*)context;


/**
 定义需要接收的module

 @return modules
 */
- (NSArray *)customeSubscribeModule;

/**
 定义需要接收的行为

 @return actions
 */
- (NSArray*)customeSubscribeActions;


/** 是否缓存当前类对象 noti:controller会被导航控制器强引用能够接收到消息 而NSObject则会被释放掉 */
- (BOOL)ydoc_cacheImplementer;

@end

NS_ASSUME_NONNULL_END
