//
//  LSToastView.h
//  Pods
//
//  Created by Lyson on 2019/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSToastView : UIView

/// 显示Toast
/// @param view view
/// @param message message
/// @param duration 周期
+ (void)showToast:(UIView *)view
         message:(NSString *)message
         duration:(CGFloat)duration;

@end

NS_ASSUME_NONNULL_END
