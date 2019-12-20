//
//  UINavigationController+LSKit.h
//  Pods
//
//  Created by Lyson on 2019/9/12.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (LSKit)

/// 设置导航栏颜色
/// @param color color
/// @param alpha alpha
- (void)ls_setNavigationBarColor:(UIColor *)color alpha:(CGFloat)alpha;

/// 删除NavigationController子控制器
/// @param vcName vcname
- (void)ls_removeViewControllerWithViewControllerName:(NSString *)vcName;

/// 是否包含自控制器
/// @param child child
- (BOOL)ls_haveChildViewControllers:(NSString *)child;

/// 添加子控制器到NavigationController
/// @param viewControlle 控制器
/// @param index index
- (void)ls_insertViewControlle:(NSString *)viewControlle index:(NSInteger)index;

/// 跳到某个界面
/// @param vcName 控制器类名
/// @param animated animation
- (void)ls_popToViewControllerWithVCName:(NSString *)vcName animated:(BOOL)animated;

@end
