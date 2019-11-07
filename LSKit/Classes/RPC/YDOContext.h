//
//  FDContext.h
//  Pods
//
//  Created by Lyson on 2019/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN





/**
 上下文配置数据
 */
@interface YDOContext : NSObject

@property (nonatomic , copy) NSDictionary *data;
@property (nonatomic , copy) NSString *event;

@end

NS_ASSUME_NONNULL_END
