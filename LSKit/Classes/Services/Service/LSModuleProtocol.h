//
//  FDModuleProtocol.h
//  Pods
//
//  Created by Lyson on 2019/4/11.
//
#import "LSContext.h"
#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@protocol LSModuleProtocol <NSObject>
@optional

/**
 通知组件已注册
 */
-(void)lsModuleDidRegister;


/**
 自定义消息 格式为:module:action

 @param context 消息上下文
 */
-(void)moduleCustomEvent:(LSContext*)context;

-(void)moduleApplicationFinishLaunch:(LSContext*)context;


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

@end

NS_ASSUME_NONNULL_END
