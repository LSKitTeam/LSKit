//
//  FDAnnotation.h
//  Pods
//
//  Created by Lyson on 2019/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef LSDingKitModName
#define LSDingKitModName     "LSKitModName"
#endif

#ifndef LSDingKitServiceName
#define LSDingKitServiceName "LSKitSerName"
#endif

#define LSDingKitDATA(sectName) __attribute((used, section("__DATA,"#sectName " ")))

/** 组件注解 通过该宏来标注组件 */
#define LSDingKitMod(name) \
    char *k ## name ## _mod LSDingKitDATA(LSKitModName) = ""#name "";

/**
 服务注册 处理业务逻辑   Router: router://TestFDBusViewControllerProtocol/push?key=value
 @param name 服务名 */
#define LSDingKitService(service, impl) \
    char *k ## service ## _ser \
    LSDingKitDATA(LSKitSerName) = "{ \""#service "\" : \""#impl "\"}";

/** 注解及解析 */
@interface LSAnnotation : NSObject

@end

NS_ASSUME_NONNULL_END
