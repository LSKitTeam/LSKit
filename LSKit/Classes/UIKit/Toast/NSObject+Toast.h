//
//  NSObject+Toast.h
//  Pods
//
//  Created by Lyson on 2019/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Toast)

/// 显示Toast
/// @param message message
-(void)ls_toast:(NSString*)message;

/// 显示toast
/// @param message message
/// @param duration duration
-(void)ls_toast:(NSString*)message duration:(CGFloat)duration;

@end

NS_ASSUME_NONNULL_END
