//
//  LSBaseRequest.m
//  LSKit
//
//  Created by Lyson on 2019/9/14.
//

#import "LSBaseRequest.h"

#import "LSRequestCertificationPolicy.h"

//默认超时时间
NSTimeInterval const defaultTimeInterval = 8;

@implementation LSBaseRequest

/**
 实例化请求体

 @param URL URL
 @param method POST GET PUT
 @param body 请求体
 @param header header
 @return instance
 */
- (instancetype)initWithUrl:(NSString *)URL
                     Method:(LSBaseRequest_Method)method
                       body:(NSDictionary *)body
                     header:(NSDictionary *)header {

    if (self = [self initWithUrl:URL
                          Method:method
                            body:body
                          header:header
                requestSerialize:LSBaseRequestSerializeType_JSON
               responseSerialize:LSBaseResponseSerializeType_JSON]) {
    }
    return self;
}

/**
 初始化

 @param URL URL
 @param method Method POST PUT ...
 @param body Body
 @param header header
 @param requestSerialize 请求序列化
 @param responseSerialize 返回序列化
 @return 回调结果
 */
- (instancetype)initWithUrl:(NSString *)URL
                     Method:(LSBaseRequest_Method)method
                       body:(NSDictionary *)body
                     header:(NSDictionary *)header
           requestSerialize:(LSBaseRequestSerializeType)requestSerialize
          responseSerialize:(LSBaseResponseSerializeType)responseSerialize {

    if (self = [super init]) {

        _retryInterval = 0;
        _timeOutInterval = defaultTimeInterval;
        _method = method;
        _bodyParam = body;
        _headerParam = header;
        _absoluteURL = URL;
        self.requestSerializer = requestSerialize;
        self.responseSerializer = responseSerialize;
    }

    return self;
}

@end
