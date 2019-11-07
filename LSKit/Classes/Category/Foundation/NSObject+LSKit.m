//
//  NSObject+LSKit.m
//  Pods
//
//  Created by Lyson on 2019/9/29.
//

#import "NSObject+LSKit.h"
#import <objc/runtime.h>

@implementation NSObject (LSKit)


/// 替换方法
/// @param theClass 替换方法的类
/// @param originalSelector originalSelector
/// @param swizzledSelector swizzledSelector
+(void)ls_swizzleSelectorClass:(Class)theClass originalMethod:(SEL)originalSelector swizzledMethod:(SEL)swizzledSelector{
    
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}


/// 新增方法
/// @param theClass 新增方法的类
/// @param selector Sel
/// @param method 编码
+(BOOL)ls_addMethod:(Class)theClass selector:(SEL)selector method:(Method)method{
    
    return class_addMethod(theClass, selector,  method_getImplementation(method),  method_getTypeEncoding(method));
}

@end
