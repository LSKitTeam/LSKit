//
//  LSBaseUploadRequest.h
//  LSKit
//
//  Created by Lyson on 2019/9/15.
//

#import "LSBaseRequest.h"
@class LSRequestUploadFileModel;

@interface LSBaseUploadRequest<__covariant ObjectType> : LSBaseRequest

/**
 上传文件初始化 Method默认LSBaseRequest_Method_UploadFile_POST

 @param URL URL
 @param body body
 @param header header
 @param uploadData 上传数据 NSArray<LSRequestUploadFileModel*>*
 @param requestSerialize 请求序列化
 @param responseSerialize 回调序列化
 @return instance
 */
- (instancetype)initWithUrl:(NSString *)URL
                       body:(NSDictionary *)body
                     header:(NSDictionary *)header
                 uploadData:(NSArray<LSRequestUploadFileModel *> *)uploadData
           requestSerialize:(LSBaseRequestSerializeType)requestSerialize
          responseSerialize:(LSBaseResponseSerializeType)responseSerialize;

/**
 上传文件数据
 */
@property (nonatomic, readonly, strong)
    NSArray<LSRequestUploadFileModel *> *uploadData;

@end
