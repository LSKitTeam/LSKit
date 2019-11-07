//
//  NSObject+LSRpc.h
//  Pods
//
//  Created by Lyson on 2019/11/1.
//


#import <Foundation/Foundation.h>

#import "YDOLrpc.h"

@interface NSObject (LSRpc)

@property (nonatomic, assign) NSMutableDictionary *rpcCacheDictionary;
@end
