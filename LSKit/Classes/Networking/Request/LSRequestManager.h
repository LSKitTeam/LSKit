//
//  LSRequestManager.h
//  LSKit
//
//  Created by Lyson on 2019/9/14.
//

#import <Foundation/Foundation.h>
#import "LSBaseRequest.h"

@interface LSBaseRequestManager : NSObject

@end

@interface LSRequestManager : LSBaseRequestManager

+ (instancetype _Nullable)shareInstance;

/// 请求
/// @param request request
/// @param success success
/// @param failure failure
- (NSURLSessionDataTask *_Nullable)
    callRequest:(LSBaseRequest *_Nullable)request
        success:(void (^_Nullable)(id _Nullable responseObject))success
        failure:(void (^_Nullable)(NSError *_Nullable error))failure;
@end
