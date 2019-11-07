//
//  YDOPluginCommon.h
//  Pods
//
//  Created by Lyson on 2019/4/11.
//

/**
 服务回到

 @param code 状态码
 @param data 数据
 @param error 错误
 @return 结果 YES 移除掉服务管理器中创建的实例，NO不移除服务管理器中创建的实例
 */
typedef BOOL (^YDOLrpcCallback)(int code , id data , NSError *error);
typedef void (^YDOErrorCallback)(NSError *errors);

typedef NS_ENUM(NSInteger,YDOServiceResponseType) {
    
    YDOServiceResponseType_Success = 0,
    YDOServiceResponseType_Fail = 1,
    YDOServiceResponseType_Step = 10000,
    YDOServiceResponseType_TimeOut = 10,
    YDOServiceResponseType_BadNet = 100,
    
};

#ifdef DEBUG
#define YDODingLog(x, ...) NSLog(x, ## __VA_ARGS__);
#else
#define YDODingLog(x, ...)
#endif

