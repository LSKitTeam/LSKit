//
//  UIDevice+LSKit.h
//  LSKit
//
//  Created by Lyson on 2019/9/13.
//

#import <UIKit/UIKit.h>

@interface UIDevice (LSKit)

/**
 WIFI ip地址
 
 @return ipAdd
 */
+ (NSString *)ipAddressWIFI;

/**
 app版本
 
 @return 版本号
 */
+ (NSString *)appVersion;

/**
 编译版本
 
 @return 版本号
 */
+ (NSString *)buildVersion;

/**
 系统版本
 
 @return 版本号
 */
+ (NSString *)appSystemVersion;

/**
 获取设备类型
 
 @return 设备类型
 */
+ (NSString *)deviceModel;

@end
