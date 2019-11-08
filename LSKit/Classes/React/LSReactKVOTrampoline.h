//
//  LSReactKVOTrampoline.h
//  Pods
//
//  Created by Lyson on 2019/10/4.
//

#import <Foundation/Foundation.h>
#import "LSReactSubscribe.h"

@interface LSReactKVOTrampoline : NSObject

@property (nonatomic, assign , readonly) BOOL isGlobal;
/// 初始化
/// @param subscribe subscribe
/// @param weakTarget weakTarget
/// @param keypath keypath
//  @param isTopic 话题订阅
- (instancetype)initWithSubscribe:(LSReactSubscribe *)subscribe
                    observeTarget:(__weak id)weakTarget
                          keypath:(NSString *)keypath
                          isGlobal:(BOOL)isGlobal;
@end
