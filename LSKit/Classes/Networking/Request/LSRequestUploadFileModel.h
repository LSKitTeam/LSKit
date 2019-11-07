//
//  LSRequestUploadFileModel.h
//  LSKit
//
//  Created by Lyson on 2019/9/15.
//

#import <Foundation/Foundation.h>

@interface LSRequestUploadFileModel : NSObject

/**
 上传文件数据
 */
@property (nonatomic, strong) NSData *uploadData;

/**
 上传文件数据名
 */
@property (nonatomic, copy) NSString *uploadDataName;

/**
 上传文件后缀
 */
@property (nonatomic, copy) NSString *uploadFileName;

/**
 上传文件类型 传输用
 */
@property (nonatomic, copy) NSString *uploadMiMEType;

@end
