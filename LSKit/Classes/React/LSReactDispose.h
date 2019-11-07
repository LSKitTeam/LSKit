//
//  LSReactDispose.h
//  Pods
//
//  Created by Lyson on 2019/10/2.
//

#import <Foundation/Foundation.h>

@class LSReactSignal;

@interface LSReactDispose : NSObject

@property (nonatomic, weak) LSReactSignal *signal;

/// 释放
- (void)dispose;

@end
