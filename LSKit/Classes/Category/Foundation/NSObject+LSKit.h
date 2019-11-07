//
//  NSObject+LSKit.h
//  Pods
//
//  Created by Lyson on 2019/9/29.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (LSKit)

/// 替换方法
/// @param theClass 替换方法的类
/// @param originalSelector originalSelector
/// @param swizzledSelector swizzledSelector
+(void)ls_swizzleSelectorClass:(Class)theClass originalMethod:(SEL)originalSelector swizzledMethod:(SEL)swizzledSelector;

/// 新增方法
/// @param theClass 新增方法的类
/// @param selector Sel
/// @param method 编码
+(BOOL)ls_addMethod:(Class)theClass selector:(SEL)selector method:(Method)method;

@end
