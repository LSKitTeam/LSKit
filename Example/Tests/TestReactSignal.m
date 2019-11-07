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

@interface TestURLRequestObj : NSObject

@property (nonatomic, copy) NSString *testString;
@end

@implementation TestURLRequestObj

- (instancetype)init {
    if (self = [super init]) {
        _testString = @"aaaaaaaaa";
    }
    return self;
}

- (void)dealloc {
    NSLog(@"释放了 %@", self.description);
}

@end

@interface TestReactSignal : XCTestCase

@property (nonatomic, strong) TestURLRequestObj *testObj;
@end

@implementation TestReactSignal

- (void)setUp {
    self.testObj = [TestURLRequestObj new];
}

- (void)tearDown {
    self.testObj = nil;
}

- (void)testSignal {

    XCTestExpectation *exception = [self expectationWithDescription:@"----"];

    TestURLRequestObj *obj = [TestURLRequestObj new];
    [[obj ls_valuesForKeyPath:@"testString"]
        subscribe:^(id value) {

            [exception fulfill];
            NSLog(@"changeValue :%@", value);
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

- (void)testSkipSignal {

    XCTestExpectation *exception = [self expectationWithDescription:@"----"];

    __block NSInteger count = 0;
    [[[self.testObj ls_valuesForKeyPath:@"testString"]
        skip:1] subscribe:^(id value) {
        NSLog(@"changeValue : %@ %@", value, [NSThread currentThread]);
        count++;
        if (count == 5) {
            [exception fulfill];
        }
    }];

    dispatch_queue_t queue =
        dispatch_queue_create("test.com.test", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{

        self.testObj.testString = @"1";
    });
    dispatch_async(queue, ^{

        self.testObj.testString = @"2";
    });
    dispatch_async(queue, ^{

        self.testObj.testString = @"3";
    });
    dispatch_async(queue, ^{

        self.testObj.testString = @"4";
    });
    dispatch_async(queue, ^{

        self.testObj.testString = @"5";
    });

    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError *_Nullable error) {
                                     if (error) {
                                         XCTFail(@"请求失败");
                                     } else {
                                         NSLog(@"请求成功");
                                     }

                                 }];
}

- (void)testNullSignal {

    XCTestExpectation *exception = [self expectationWithDescription:@"----"];

    __block NSInteger count = 0;
    [[[self.testObj ls_valuesForKeyPath:@"testString"]
        skip:0] subscribe:^(id value) {

        count++;

        NSLog(@"changeValue : %@ %@,%@", value, [NSThread currentThread],
              @(count));

        if (count == 6) {
            [exception fulfill];
        }
    }];

    dispatch_queue_t queue =
        dispatch_queue_create("test.com.test", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{

        self.testObj.testString = @"1";
    });
    dispatch_async(queue, ^{

        self.testObj.testString = @"2";
    });
    dispatch_async(queue, ^{

        self.testObj.testString = @"3";
    });
    dispatch_async(queue, ^{

        self.testObj.testString = @"4";
    });
    dispatch_async(queue, ^{

        self.testObj.testString = @"5";
    });

    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError *_Nullable error) {
                                     if (error) {
                                         XCTFail(@"请求失败");
                                     } else {
                                         NSLog(@"请求成功");
                                     }

                                 }];
}

- (void)testMapSignal {

    XCTestExpectation *exception = [self expectationWithDescription:@"----"];

    __block NSInteger count = 0;
    [[[self.testObj ls_valuesForKeyPath:@"testString"]
        map:^BOOL(id value) {

            if ([value integerValue] == 4) {
                return NO;
            }
            return YES;
        }] subscribe:^(id value) {

        count++;

        NSLog(@"changeValue : %@", value);

        if (count == 5) {
            [exception fulfill];
        }
    }];

    dispatch_queue_t queue =
        dispatch_queue_create("test.com.test", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{

        self.testObj.testString = @"1";
    });
    dispatch_async(queue, ^{

        self.testObj.testString = @"2";
    });
    dispatch_async(queue, ^{

        self.testObj.testString = @"3";
    });
    dispatch_async(queue, ^{

        self.testObj.testString = @"4";
    });
    dispatch_async(queue, ^{

        self.testObj.testString = @"5";
    });

    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError *_Nullable error) {
                                     if (error) {
                                         XCTFail(@"请求失败");
                                     } else {
                                         NSLog(@"请求成功");
                                     }

                                 }];
}


@end
