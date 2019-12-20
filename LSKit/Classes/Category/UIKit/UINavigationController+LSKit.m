//
//  UINavigationController+LSKit.m
//  Pods
//
//  Created by Lyson on 2019/9/12.
//

#import "UINavigationController+LSKit.h"

static inline UIImage  *lsColorConversionImage(UIColor * color) {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@implementation UINavigationController (LSKit)


/// 设置导航栏颜色
/// @param color color
/// @param alpha alpha 
- (void)ls_setNavigationBarColor:(UIColor *)color alpha:(CGFloat)alpha {
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    UIImage * image = lsColorConversionImage([color colorWithAlphaComponent:alpha]);
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}


/// 删除NavigationController子控制器
/// @param vcName vcname
- (void)ls_removeViewControllerWithViewControllerName:(NSString *)vcName {
    NSMutableArray *arrayM = @[].mutableCopy;
    NSArray *viewControllers = self.viewControllers;
    if (viewControllers.count <= 1) return;
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:NSClassFromString(vcName)]) [arrayM addObject:obj];
    }];
    [self setViewControllers:arrayM];
}


/// 是否包含自控制器
/// @param child child
- (BOOL)ls_haveChildViewControllers:(NSString *)child {
    NSArray *arrayVC = self.viewControllers;
    BOOL haveChild = NO;
    for (UIViewController *obj in arrayVC) {
        if ([obj isKindOfClass:NSClassFromString(child)]) {
            haveChild = YES;
            break;
        }
    }
    return haveChild;
}


/// 添加子控制器到NavigationController
/// @param viewControlle 控制器
/// @param index index
- (void)ls_insertViewControlle:(NSString *)viewControlle index:(NSInteger)index {
    NSMutableArray *arrayVC = self.viewControllers.mutableCopy;
    if (index >= arrayVC.count) return;
    UIViewController *vc = [NSClassFromString(viewControlle) new];
    if (vc == nil) return;
    [arrayVC insertObject:vc atIndex:index];
//    if (arrayVC.count > 0) vc.hidesBottomBarWhenPushed = YES;
    [self setViewControllers:arrayVC.copy];
}


/// 跳到某个界面
/// @param vcName 控制器类名
/// @param animated animation
- (void)ls_popToViewControllerWithVCName:(NSString *)vcName animated:(BOOL)animated {
    NSArray *arrayVC = self.viewControllers;
    if (arrayVC.count <= 1) return;
    [arrayVC enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(vcName)]){
            [self popToViewController:obj animated:animated];
            *stop = YES;
        }
    }];
}

@end
