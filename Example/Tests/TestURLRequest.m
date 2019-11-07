//
//  Category-Foundation.m
//  LSKit_Tests
//
//  Created by Lyson on 2019/9/12.
//  Copyright © 2019 542634994@qq.com. All rights reserved.
//

@import XCTest;

#import <OHHTTPStubs/OHHTTPStubs.h>
#import <LSKit/LSKit.h>

extern NSString *const AFNetworkingOperationFailingURLResponseErrorKey;

@interface TestURLRequest : XCTestCase
@property (nonatomic, strong) id<OHHTTPStubsDescriptor> stubDes;
@end

@implementation TestURLRequest

- (void)setUp {
    [self initURLHost];
}

- (void)initURLHost {

    self.stubDes = [OHHTTPStubs
        stubRequestsPassingTest:^BOOL(NSURLRequest *_Nonnull request) {
            BOOL returnURL = YES;
            return returnURL;
        }
        withStubResponse:^OHHTTPStubsResponse *_Nonnull(
            NSURLRequest *_Nonnull request) {

            NSDictionary *values = @{ @"key" : @"value", @"key1" : @"value2" };

            NSData *data = [[values ls_jsonStringEncoded]
                dataUsingEncoding:NSUTF8StringEncoding];

            int responseCode = 200;

            if ([request.URL.absoluteString
                    isEqualToString:@"http//test.com/testUrl"]) {
                responseCode = 200;
            } else if ([request.URL.absoluteString
                           isEqualToString:@"http//test.com/testUrl1"]) {
                responseCode = 500;
            } else if ([request.URL.absoluteString
                           isEqualToString:@"http//test.com/testUrl2"]) {
                responseCode = 404;
            }

            return [OHHTTPStubsResponse
                responseWithData:data
                      statusCode:responseCode
                         headers:@{
                             @"Content-Type" : @"application/json"
                         }];
        }];
}

- (void)tearDown {

    [OHHTTPStubs removeStub:self.stubDes];
}

- (void)testPost200 {

    LSBaseRequest *request = [self request:@"http//test.com/testUrl"];
    XCTestExpectation *exception =
        [self expectationWithDescription:request.absoluteURL];
    [self ls_callRequest:request
        success:^(id _Nonnull responseObject) {
            [exception fulfill];
        }
        failure:^(NSError *_Nonnull error) {
            XCTFail(@"请求失败");
        }];

    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError *_Nullable error) {
                                     if (error) {
                                         XCTFail(@"请求失败");
                                     } else {
                                         NSLog(@"请求成功");
                                     }
                                 }];
}

- (void)testPost404 {

    LSBaseRequest *request = [self request:@"http//test.com/testUrl2"];
    XCTestExpectation *exception =
        [self expectationWithDescription:request.absoluteURL];
    [self ls_callRequest:request
        success:^(id _Nonnull responseObject) {
            XCTFail(@"状态不对");
        }
        failure:^(NSError *_Nonnull error) {

            NSHTTPURLResponse *response = [error.userInfo
                objectForKey:AFNetworkingOperationFailingURLResponseErrorKey];

            [exception fulfill];
            XCTAssertEqual(response.statusCode, 404);
        }];

    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError *_Nullable error) {
                                     if (error) {
                                         XCTFail(@"请求失败");
                                     } else {
                                         NSLog(@"请求成功");
                                     }
                                 }];
}

- (void)testPost500 {

    LSBaseRequest *request = [self request:@"http//test.com/testUrl1"];
    XCTestExpectation *exception =
        [self expectationWithDescription:request.absoluteURL];
    [self ls_callRequest:request
        success:^(id _Nonnull responseObject) {
            XCTFail(@"状态不对");
        }
        failure:^(NSError *_Nonnull error) {

            NSHTTPURLResponse *response = [error.userInfo
                objectForKey:AFNetworkingOperationFailingURLResponseErrorKey];

            [exception fulfill];
            XCTAssertEqual(response.statusCode, 500);
        }];

    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError *_Nullable error) {
                                     if (error) {
                                         XCTFail(@"请求失败");
                                     } else {
                                         NSLog(@"请求成功");
                                     }
                                 }];
}

- (void)testCancelRequest {

    LSBaseRequest *request = [self request:@"http//test.com/cancel"];
    XCTestExpectation *exception =
        [self expectationWithDescription:request.absoluteURL];
    NSString *requestIndentifire = [self ls_callRequest:request
        success:^(id _Nonnull responseObject) {
            XCTFail(@"状态不对");
        }
        failure:^(NSError *_Nonnull error) {

            [exception fulfill];
            XCTAssertEqual(error.code, -999);

        }];

    [self ls_cancelTask:requestIndentifire];

    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError *_Nullable error) {
                                     if (error) {
                                         XCTFail(@"请求失败");
                                     } else {
                                         NSLog(@"请求成功");
                                     }
                                 }];
}

- (void)testAllCancelRequest {

    LSBaseRequest *request = [self request:@"http//test.com/cancel"];
    XCTestExpectation *exception =
        [self expectationWithDescription:request.absoluteURL];
    [self ls_callRequest:request
        success:^(id _Nonnull responseObject) {
            XCTFail(@"状态不对");
        }
        failure:^(NSError *_Nonnull error) {

            [exception fulfill];
            XCTAssertEqual(error.code, -999);

        }];

    [self ls_cancelAllRequest];

    __weak typeof(self) weakSelf = self;
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError *_Nullable error) {
                                     if (error) {
                                         XCTFail(@"请求失败");
                                     } else {
                                         NSLog(@"请求成功");
                                     }

                                     NSLog(@"%@", weakSelf.networks);
                                     NSLog(@"请求成功");
                                 }];
}

- (LSBaseRequest *)request:(NSString *)URL {

    LSBaseRequest *request =
        [[LSBaseRequest alloc] initWithUrl:URL
                                    Method:LSBaseRequest_Method_POST
                                      body:nil
                                    header:@{
                                        @"Content-Type" : @"application/json"
                                    }];

    return request;
}

@end
