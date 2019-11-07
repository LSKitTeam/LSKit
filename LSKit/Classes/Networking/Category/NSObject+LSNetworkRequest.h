//
//  NSObject+LSNetworkRequest.h
//  LSKit
//
//  Created by Lyson on 2019/9/29.
//

#import <Foundation/Foundation.h>
#import "LSBaseRequest.h"
#import "LSBaseUploadRequest.h"

@interface NSObject (LSNetworkRequest)

@property (nonatomic, copy) NSHashTable *_Nullable networks;

/// 请求
/// @param URL URL
/// @param method Method
/// @param parameter 请求体
/// @param httpHeader http请求体
/// @param success success
/// @param failure failure
/// return NSString 请求唯一标识符
- (NSString *_Nullable)
    ls_callRequest:(NSString *_Nullable)URL
         method:(LSBaseRequest_Method)method
      parameter:(NSDictionary *_Nullable)parameter
         header:(NSDictionary *_Nullable)httpHeader
        success:(void (^_Nullable)(id _Nonnull responseObject))success
        failure:(void (^_Nullable)(NSError *_Nonnull error))failure;

/// 上传
/// @param URL URL
/// @param method method
/// @param parameter parameter
/// @param httpHeader httpHeader
/// @param uploadData uploadData
/// @param success success
/// @param failure failure
/// return NSString 请求唯一标识符
- (NSString *_Nullable)
    ls_uploadRequest:(NSString *_Nullable)URL
           method:(LSBaseRequest_Method)method
        parameter:(NSDictionary *_Nullable)parameter
           header:(NSDictionary *_Nullable)httpHeader
       uploadData:(NSArray<LSRequestUploadFileModel *> *_Nullable)uploadData
          success:(void (^_Nullable)(id _Nonnull responseObject))success
          failure:(void (^_Nullable)(NSError *_Nonnull error))failure;

/// 直接请求
/// @param request LSBaseRequest LSBaseUploadRequest
/// @param success success
/// @param failure failure
/// return NSString 请求唯一标识符
- (NSString *_Nullable)
    ls_callRequest:(__kindof LSBaseRequest *_Nullable)request
        success:(void (^_Nullable)(id _Nullable responseObject))success
        failure:(void (^_Nullable)(NSError *_Nullable error))failure;

/// 取消请求
/// @param taskIndentifire 请求标示
- (void)ls_cancelTask:(NSString *_Nullable)taskIndentifire;

/// 取消当前类的所有请求
- (void)ls_cancelAllRequest;

@end
