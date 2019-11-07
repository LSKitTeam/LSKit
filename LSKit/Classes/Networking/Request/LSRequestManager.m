//
//  LSRequestManager.m
//  LSKit
//
//  Created by Lyson on 2019/9/14.
//

#import "LSRequestManager.h"
#import "LSRequestCertificationPolicy.h"
#import "LSRequestUploadFileModel.h"
#import <AFNetworking/AFNetworking.h>

typedef void (^CompleteBlock)(NSURLResponse *response, id data, NSError *error);

typedef void (^ProgrossBlock)(NSURLResponse *response, id data, NSError *error);

@interface LSRequestManager ()

@end

@implementation LSRequestManager

+ (instancetype)shareInstance {

    static LSRequestManager *_instance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });

    return _instance;
}

@end

@interface LSBaseRequestManager ()

/**
 请求
 */
@property (nonatomic, strong) LSBaseRequest *request;

@end

@implementation LSBaseRequestManager

+ (instancetype _Nullable)shareInstance {

    static LSBaseRequestManager *_instance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });

    return _instance;
}

/// 请求
/// @param request request
/// @param success success
/// @param failure failure
- (NSURLSessionDataTask *_Nullable)
    callRequest:(LSBaseRequest *_Nullable)request
        success:(void (^_Nullable)(id _Nullable responseObject))success
        failure:(void (^_Nullable)(NSError *_Nullable error))failure {

    CompleteBlock complete =
        ^(NSURLResponse *response, id data, NSError *error) {
            if (!error) {
                success(data);
            } else {
                failure(error);
            }
        };

    self.request = request;
    if (self.request.method == LSBaseRequest_Method_POST) {
        return [self POST:complete];
    } else if (self.request.method == LSBaseRequest_Method_GET) {
        return [self GET:complete];
    } else if (self.request.method == LSBaseRequest_Method_PUT) {
        return [self DELETE:complete];
    } else if (self.request.method == LSBaseRequest_Method_DELETE) {
        return [self PUT:complete];
    } else if (self.request.method == LSBaseRequest_Method_UploadFile_POST) {
        return [self Upload_File:complete];
    }
    return nil;
}

- (NSURLSessionDataTask *)POST:(CompleteBlock)completeBlock {
    AFHTTPSessionManager *manager = [self defaultManager];
    [self packageHeaders:manager];
    NSURLSessionDataTask *task = [manager POST:self.request.absoluteURL
        parameters:self.request.bodyParam
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            completeBlock(task.response, responseObject, nil);
        }
        failure:^(NSURLSessionDataTask *_Nullable task,
                  NSError *_Nonnull error) {
            completeBlock(task.response, nil, error);
        }];
    // resume suspend cancel
    return task;
}

- (NSURLSessionDataTask *)GET:(CompleteBlock)completeBlock {
    AFHTTPSessionManager *manager = [self defaultManager];
    [self packageHeaders:manager];
    NSURLSessionDataTask *task = [manager GET:self.request.absoluteURL
        parameters:self.request.bodyParam
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            completeBlock(task.response, responseObject, nil);
        }
        failure:^(NSURLSessionDataTask *_Nullable task,
                  NSError *_Nonnull error) {
            completeBlock(task.response, nil, error);
        }];

    return task;
}

- (NSURLSessionDataTask *)DELETE:(CompleteBlock)completeBlock {
    AFHTTPSessionManager *manager = [self defaultManager];
    [self packageHeaders:manager];
    NSURLSessionDataTask *task = [manager DELETE:self.request.absoluteURL
        parameters:self.request.bodyParam
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            completeBlock(task.response, responseObject, nil);
        }
        failure:^(NSURLSessionDataTask *_Nullable task,
                  NSError *_Nonnull error) {
            completeBlock(task.response, nil, error);
        }];

    return task;
}

- (NSURLSessionDataTask *)PUT:(CompleteBlock)completeBlock {
    AFHTTPSessionManager *manager = [self defaultManager];
    [self packageHeaders:manager];
    NSURLSessionDataTask *task = [manager PUT:self.request.absoluteURL
        parameters:self.request.bodyParam
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            completeBlock(task.response, responseObject, nil);
        }
        failure:^(NSURLSessionDataTask *_Nullable task,
                  NSError *_Nonnull error) {
            completeBlock(task.response, nil, error);
        }];

    return task;
}

- (NSURLSessionDataTask *)Upload_File:(CompleteBlock)completeBlock {
    return nil;
}

- (AFHTTPSessionManager *)defaultManager {
    AFHTTPSessionManager *manager = [LSRequestManager httpManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = [self.request timeOutInterval];
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;

    if (self.request.certificationPolicy) {

        AFSecurityPolicy *secPolicy = [AFSecurityPolicy
             policyWithPinningMode:(AFSSLPinningMode) self.request
                                       .certificationPolicy.SSLPinningMode
            withPinnedCertificates:self.request.certificationPolicy
                                       .pinnedCertificates];
        secPolicy.allowInvalidCertificates =
            self.request.certificationPolicy.allowInvalidCertificates;
        secPolicy.validatesDomainName =
            self.request.certificationPolicy.validatesDomainName;
        manager.securityPolicy = secPolicy;
    }

    [manager.requestSerializer setValue:@"application/json"
                     forHTTPHeaderField:@"Content-Type"];

    manager.responseSerializer.acceptableContentTypes =
        [NSSet setWithObjects:@"application/json", @"text/json",
                              @"text/javascript", @"text/html", nil];
    return manager;
}

+ (AFHTTPSessionManager *)httpManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration =
            [NSURLSessionConfiguration defaultSessionConfiguration];
        manager = [[AFHTTPSessionManager alloc]
            initWithSessionConfiguration:configuration];
    });
    return manager;
}

- (void)packageHeaders:(AFHTTPSessionManager *)manager {

    [self.request.headerParam enumerateKeysAndObjectsUsingBlock:^(
                                  id key, id obj, BOOL *_Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}

- (NSString *)objToJson:(id)response {
    if (![response isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    if (![NSJSONSerialization isValidJSONObject:response]) {
        return [NSString stringWithFormat:@"%@", response];
    }

    NSData *jsonData =
        [NSJSONSerialization dataWithJSONObject:response
                                        options:NSJSONWritingPrettyPrinted
                                          error:nil];
    NSString *jsonString =
        [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
@end
