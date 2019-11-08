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

@interface TestURLRequestObj1 : NSObject

@property (nonatomic, copy) NSString *testString;
@end

@implementation TestURLRequestObj1

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

@interface TestReactSignal1 : XCTestCase

@property (nonatomic, strong) TestURLRequestObj1 *testObj;
@end

@implementation TestReactSignal1

- (void)setUp {
    self.testObj = [TestURLRequestObj1 new];

    [[self.testObj ls_valuesForKeyPath:@"testString"] subscribe:^(id value) {

        NSLog(@"changeValue :%@", value);
    }];
    
    [[self.testObj ls_valuesForGlobalKeyPath:@"testString2"] subscribe:^(id value) {

        NSLog(@"topicValue :%@", value);
    }];
}

- (void)tearDown {
    self.testObj = nil;
}

- (void)testSignal1 {

    self.testObj.testString = @"测试测试";
 
    [self.testObj ls_sendSignal:@"testString2" values:@"测试测试Topic"];
 
}

@end
