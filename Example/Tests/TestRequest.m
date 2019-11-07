//
//  Category-Foundation.m
//  LSKit_Tests
//
//  Created by Lyson on 2019/9/12.
//  Copyright © 2019 542634994@qq.com. All rights reserved.
//

@import XCTest;

#import <LSKit/LSKit.h>

@interface TestRequest : XCTestCase

@property (nonatomic, strong) LSBaseRequest *request;
@end

@implementation TestRequest

- (void)tearDown {
}

- (void)testGETRequest {

    LSBaseRequest_Method method = LSBaseRequest_Method_GET;

    [self initWithMethod:method];
}

- (void)testPOSTRequest {

    LSBaseRequest_Method method = LSBaseRequest_Method_POST;

    [self initWithMethod:method];
}

- (void)testDELETERequest {

    LSBaseRequest_Method method = LSBaseRequest_Method_DELETE;

    [self initWithMethod:method];
}

- (void)testPUTRequest {

    LSBaseRequest_Method method = LSBaseRequest_Method_PUT;

    [self initWithMethod:method];
}

- (void)testUploadFileData {
    
    NSString *absoluteURL = @"http://baidu.com";
    NSDictionary *body = [NSDictionary
                          dictionaryWithObjectsAndKeys:@"value1", @"key1", @"value2", @"key2",
                          @"value3", @"key3", nil];
    
    NSDictionary *header = [NSDictionary
                            dictionaryWithObjectsAndKeys:@"headerV1", @"key1", @"headerV2", @"key2",
                            @"headerV3", @"key3", nil];
    
    NSMutableArray *uploadData = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0 ; i < 3; i++) {
        
        LSRequestUploadFileModel *model = [LSRequestUploadFileModel new];
        model.uploadFileName = @"uploadFileName";
        model.uploadDataName = @"uploadDataName";
        model.uploadMiMEType = @"uploadMiMEType";
        model.uploadData = [@"uploadData" dataUsingEncoding:NSUTF8StringEncoding];
        [uploadData addObject:model];
    }
    
    [self initRequest:absoluteURL body:body header:header uploadData:uploadData requestSerialize:LSBaseRequestSerializeType_JSON responseSerialize:LSBaseResponseSerializeType_JSON];
}


- (void)initWithMethod:(LSBaseRequest_Method)method {

    NSString *absoluteURL = @"http://baidu.com";
    NSDictionary *body = [NSDictionary
        dictionaryWithObjectsAndKeys:@"value1", @"key1", @"value2", @"key2",
                                     @"value3", @"key3", nil];

    NSDictionary *header = [NSDictionary
        dictionaryWithObjectsAndKeys:@"headerV1", @"key1", @"headerV2", @"key2",
                                     @"headerV3", @"key3", nil];

    [self initRequest:absoluteURL body:body header:header method:method];
}

- (void)initRequest:(NSString *)absoluteURL
               body:(NSDictionary *)body
             header:(NSDictionary *)header
             method:(LSBaseRequest_Method)method {

    LSBaseRequestSerializeType requestSerialize =
        LSBaseRequestSerializeType_JSON;
    LSBaseResponseSerializeType responseSerialize =
        LSBaseResponseSerializeType_JSON;

    [self initRequest:absoluteURL
                     body:body
                   header:header
                   method:method
         requestSerialize:requestSerialize
        responseSerialize:responseSerialize];
}

- (void)initRequest:(NSString *)absoluteURL
                 body:(NSDictionary *)body
               header:(NSDictionary *)header
               method:(LSBaseRequest_Method)method
     requestSerialize:(LSBaseRequestSerializeType)requestSerialize
    responseSerialize:(LSBaseResponseSerializeType)responseSerialize {

    NSString *headerJson = [header ls_jsonStringEncoded];
    NSString *bodyJson = [body ls_jsonStringEncoded];

    self.request = [[LSBaseRequest alloc] initWithUrl:absoluteURL
                                               Method:method
                                                 body:body
                                               header:header
                                     requestSerialize:requestSerialize
                                    responseSerialize:responseSerialize];

    XCTAssertNotNil(self.request);

    XCTAssertEqual(self.request.method, method);

    XCTAssertNotNil(self.request.absoluteURL);

    XCTAssertEqual([self.request.absoluteURL isEqualToString:absoluteURL], YES);

    XCTAssertEqual(self.request.requestSerializer, requestSerialize);
    XCTAssertEqual(self.request.responseSerializer, responseSerialize);

    XCTAssertEqual([[self.request.headerParam ls_jsonStringEncoded]
                       isEqualToString:headerJson],
                   YES);
    XCTAssertEqual([[self.request.bodyParam ls_jsonStringEncoded]
                       isEqualToString:bodyJson],
                   YES);
}

- (void)initRequest:(NSString *)absoluteURL
                 body:(NSDictionary *)body
               header:(NSDictionary *)header
           uploadData:(NSArray<LSRequestUploadFileModel *> *)uploadData
     requestSerialize:(LSBaseRequestSerializeType)requestSerialize
    responseSerialize:(LSBaseResponseSerializeType)responseSerialize {

    NSString *headerJson = [header ls_jsonStringEncoded];
    NSString *bodyJson = [body ls_jsonStringEncoded];

    self.request = [[LSBaseUploadRequest alloc] initWithUrl:absoluteURL
                                                       body:body
                                                     header:header
                                                 uploadData:uploadData
                                           requestSerialize:requestSerialize
                                          responseSerialize:responseSerialize];

    XCTAssertNotNil(self.request);

    XCTAssertEqual(self.request.method, LSBaseRequest_Method_UploadFile_POST);

    XCTAssertNotNil(self.request.absoluteURL);

    XCTAssertEqual([self.request.absoluteURL isEqualToString:absoluteURL], YES);

    XCTAssertEqual(self.request.requestSerializer, requestSerialize);
    XCTAssertEqual(self.request.responseSerializer, responseSerialize);

    XCTAssertEqual([[self.request.headerParam ls_jsonStringEncoded]
                       isEqualToString:headerJson],
                   YES);
    XCTAssertEqual([[self.request.bodyParam ls_jsonStringEncoded]
                       isEqualToString:bodyJson],
                   YES);
    XCTAssertEqual(((LSBaseUploadRequest *) self.request).uploadData.count,
                   uploadData.count);

    for (LSRequestUploadFileModel *model in (
             (LSBaseUploadRequest *) self.request)
             .uploadData) {

        XCTAssertEqual([model isKindOfClass:[LSRequestUploadFileModel class]],
                       YES);
        XCTAssertNotNil(model.uploadData);
        XCTAssertNotNil(model.uploadDataName);
        XCTAssertNotNil(model.uploadFileName);
        XCTAssertNotNil(model.uploadMiMEType);
        XCTAssertEqual([model.uploadData isKindOfClass:[NSData class]],YES);
    }
}

@end
