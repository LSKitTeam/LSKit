//
//  NSObject+Toast.m
//  Pods
//
//  Created by Lyson on 2019/11/9.
//

#import "NSObject+Toast.h"
#import "LSToastView.h"


@implementation NSObject (Toast)


/// 显示Toast
/// @param message message
-(void)ls_toast:(NSString*)message{
    
    [LSToastView showToast:[UIApplication sharedApplication].keyWindow.subviews[0] message:message duration:3];
}


/// 显示toast
/// @param message message
/// @param duration duration
-(void)ls_toast:(NSString*)message duration:(CGFloat)duration{
    
    [LSToastView showToast:[UIApplication sharedApplication].keyWindow.subviews[0] message:message duration:duration];
}

@end
