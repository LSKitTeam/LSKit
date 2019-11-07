//
//  NSObject+LSNetworkRequest.m
//  LSKit
//
//  Created by Lyson on 2019/9/29.
//

#import "NSObject+LSNetworkRequest.h"
#import "NSObject+LSKit.h"
#import "LSRequestManager.h"

@implementation NSObject (LSNetworkRequest)

static const char networksArray;

#pragma mark -请求方式

/// 上传
/// @param URL URL
/// @param method method
/// @param parameter parameter
/// @param httpHeader httpHeader
/// @param uploadData uploadData
/// @param success success
/// @param failure failure
/// return NSString 请求唯一标识符
- (NSString *)ls_uploadRequest:(NSString *)URL
                     method:(LSBaseRequest_Method)method
                  parameter:(NSDictionary *)parameter
                     header:(NSDictionary *)httpHeader
                 uploadData:(NSArray<LSRequestUploadFileModel *> *)uploadData
                    success:(void (^)(id _Nonnull responseObject))success
                    failure:(void (^)(NSError *_Nonnull error))failure {
    LSBaseRequest *request = [[LSBaseUploadRequest alloc]
              initWithUrl:URL
                     body:parameter
                   header:httpHeader
               uploadData:uploadData
         requestSerialize:LSBaseRequestSerializeType_JSON
        responseSerialize:LSBaseResponseSerializeType_JSON];
    NSURLSessionTask *task =
        [[LSRequestManager shareInstance] callRequest:request
                                              success:success
                                              failure:failure];
    return [self handleTask:task];
}

/// 请求
/// @param URL URL
/// @param method Method
/// @param parameter 请求体
/// @param httpHeader http请求体
/// @param success success
/// @param failure failure
/// return NSString 请求唯一标识符
- (NSString *)ls_callRequest:(NSString *)URL
                   method:(LSBaseRequest_Method)method
                parameter:(NSDictionary *)parameter
                   header:(NSDictionary *)httpHeader
                  success:(void (^)(id _Nonnull))success
                  failure:(void (^)(NSError *_Nonnull))failure {
    LSBaseRequest *request = [[LSBaseRequest alloc] initWithUrl:URL
                                                         Method:method
                                                           body:parameter
                                                         header:httpHeader];
    NSURLSessionTask *task =
        [[LSRequestManager shareInstance] callRequest:request
                                              success:success
                                              failure:failure];
    return [self handleTask:task];
}

/// 直接请求
/// @param request LSBaseRequest LSBaseUploadRequest
/// @param success success
/// @param failure failure
/// return NSString 请求唯一标识符
- (NSString *)ls_callRequest:(LSBaseRequest *)request
                  success:(void (^)(id _Nonnull responseObject))success
                  failure:(void (^)(NSError *_Nonnull error))failure {
    NSURLSessionTask *task =
        [[LSRequestManager shareInstance] callRequest:request
                                              success:success
                                              failure:failure];
    return [self handleTask:task];
}

#pragma mark -设置环境存储请求

- (void)setNetworks:(NSHashTable *)networks {
    objc_setAssociatedObject(self, &networksArray, networks,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSHashTable *)networks {
    NSHashTable *nets = objc_getAssociatedObject(self, &networksArray);

    return nets;
}

- (NSString *)handleTask:(NSURLSessionTask *)task {

    if (!self.networks) {
        self.networks = [NSHashTable weakObjectsHashTable];
    }

    [self.networks addObject:task];

    NSString *taskIdentifire = [NSString stringWithFormat:@"%@", task];

    return taskIdentifire;
}

/// 取消请求
/// @param taskIndentifire 请求标示
- (void)ls_cancelTask:(NSString *)taskIndentifire {

    NSArray *tasks = [self.networks allObjects];

    __weak typeof(self) weakSelf = self;
    [tasks enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx,
                                        BOOL *_Nonnull stop) {

        NSString *objIdentifire = [NSString stringWithFormat:@"%@", obj];
        if ([objIdentifire isEqualToString:taskIndentifire]) {

            if ([((NSURLSessionTask *) obj) respondsToSelector:@selector(
                                                                   cancel)]) {
                [((NSURLSessionTask *) obj) cancel];
                
                [weakSelf.networks removeObject:obj];
            }
            *stop = YES;
        }

    }];
}

/// 取消当前类的所有请求
- (void)ls_cancelAllRequest {

    NSArray *tasks = [self.networks allObjects];

    [tasks enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx,
                                        BOOL *_Nonnull stop) {

        if ([((NSURLSessionTask *) obj) respondsToSelector:@selector(cancel)]) {
            [((NSURLSessionTask *) obj) cancel];
        }

    }];
    
    [self.networks removeAllObjects];
}

#pragma mark -替换方法
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel = NSSelectorFromString(@"dealloc");
        Method originalMethod = class_getInstanceMethod(self, sel);
        Method swizzledMethod =
            class_getInstanceMethod(self, @selector(ls_dealloc));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)ls_dealloc {

    if (self.networks || [self.networks allObjects] > 0) {
        [self ls_cancelAllRequest];
    }
    
    [self ls_dealloc];
}

@end
