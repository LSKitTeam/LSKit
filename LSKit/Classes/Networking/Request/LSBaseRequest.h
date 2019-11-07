//
//  LSBaseRequest.h
//  LSKit
//
//  Created by Lyson on 2019/9/14.
//

#import <Foundation/Foundation.h>

@class LSRequestCertificationPolicy;

/**
 请求方式

 - LSBaseRequest_Method_POST: POST
 - LSBaseRequest_Method_GET: GET
 - LSBaseRequest_Method_PUT: PUT
 - LSBaseRequest_Method_DELETE: DELETE
 - LSBaseRequest_Method_UploadFile_POST 上传文件
 */
typedef NS_ENUM(NSInteger, LSBaseRequest_Method) {

    LSBaseRequest_Method_POST,
    LSBaseRequest_Method_GET,
    LSBaseRequest_Method_PUT,
    LSBaseRequest_Method_DELETE,
    LSBaseRequest_Method_UploadFile_POST,
};

/**
 Request序列化 默认json

 - LSBaseRequestSerializeType_JSON: JSON
 - WPKHTTPRequestSerializeType_Other: ---NONE
 */
typedef NS_ENUM(NSInteger, LSBaseRequestSerializeType) {

    LSBaseRequestSerializeType_JSON,
    LSBaseRequestSerializeType_Other,
};

/**
 Response序列化 默认json

 - LSBaseResponseSerializeType_JSON: JSON
 - LSBaseResponseSerializeType_Other: NONE
 */
typedef NS_ENUM(NSInteger, LSBaseResponseSerializeType) {

    LSBaseResponseSerializeType_JSON,
    LSBaseResponseSerializeType_Other,
};

@interface LSBaseRequest : NSObject

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
                     header:(NSDictionary *)header;

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
          responseSerialize:(LSBaseResponseSerializeType)responseSerialize;

/**
 超时时间 默认 8s
 */
@property (nonatomic, assign) NSTimeInterval timeOutInterval;

/**
 重试频率 默认0
 */
@property (nonatomic, assign) NSInteger retryInterval;

/**
 请求方法
 */
@property (nonatomic, readonly, assign) LSBaseRequest_Method method;

/**
 请求体
 */
@property (nonatomic, readonly, copy) NSDictionary *bodyParam;

/**
 请求头
 */
@property (nonatomic, readonly, copy) NSDictionary *headerParam;

/**
 请求URL
 */
@property (nonatomic, readonly, copy) NSString *absoluteURL;

/**
 请求序列方式
 */
@property (nonatomic, assign) LSBaseRequestSerializeType requestSerializer;

/**
 回调序列方式
 */
@property (nonatomic, assign) LSBaseResponseSerializeType responseSerializer;

/**
 加密处理
 */
@property (nonatomic, strong) LSRequestCertificationPolicy *certificationPolicy;

@end
