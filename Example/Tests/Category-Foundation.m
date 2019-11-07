//
//  Category-Foundation.m
//  LSKit_Tests
//
//  Created by Lyson on 2019/9/12.
//  Copyright © 2019 542634994@qq.com. All rights reserved.
//

@import XCTest;

#import <LSKit/LSKit.h>

@interface Category_Foundation : XCTestCase

@end

@implementation Category_Foundation

- (void)testErrorUserCustom {

    NSString *domain = @"lsDomain";
    NSDictionary *errorMsg = @{ @"errorMsdg" : @"ls测试ErrorMsg" };
    NSInteger code = 11;
    NSError *error = [NSError ls_error:domain code:code infos:errorMsg];
    //测试是否可以获取ErrorMsg
    NSString *resultMsg = [error ls_errorMsg:@"errorMsdg"];

    XCTAssertNotNil(error);
    XCTAssertNotNil(resultMsg);
    XCTAssertEqual(error.code, code);
    XCTAssertEqual(error.domain, domain);
}

- (void)testVersions {

    NSString *deviceModel = [UIDevice deviceModel];
    NSString *systemVersion = [UIDevice appSystemVersion];
    NSString *appVersion = [UIDevice appVersion];
    NSString *buildVersion = [UIDevice buildVersion];

    XCTAssertNotNil(deviceModel);
    XCTAssertNotNil(systemVersion);
    XCTAssertNotNil(appVersion);
    XCTAssertNotNil(buildVersion);
}

- (void)testData {

    NSString *v = @"123123123123";
    NSString *key = @"12345678";
    NSString *iv = @"12345678";

    NSData *testData = [v dataUsingEncoding:NSUTF8StringEncoding];

    NSString *base64 = [testData ls_base64EncodedString];

    NSData *aesData = [testData ls_AES128EncryptWithKey:key iv:iv];

    NSString *desResult = [[NSString alloc]
        initWithData:[aesData ls_AES128DecryptWithKey:key iv:iv]
            encoding:NSUTF8StringEncoding];

    NSString *base64Des = [base64 ls_base64DecodedString];

    NSLog(@"%@", base64);
    NSLog(@"%@", base64Des);
    NSLog(@"AES Encry: %@", aesData);
    NSLog(@"AES descry: %@", desResult);

    XCTAssertNotNil(base64);
    XCTAssertNotNil(base64Des);
    XCTAssertNotNil(aesData);
    XCTAssertNotNil(desResult);
}

- (void)testNSDictionary {

    NSDictionary *data = [NSDictionary
        dictionaryWithObjectsAndKeys:@"1111", @"排队1", @"1", @"a", @"3",
                                     @"c", @"10", @"e", @"100", @"b", @"1111",
                                     @"排队", nil];

    NSString *json = [data ls_jsonStringEncoded];

    NSString *dicDesc = [data description];

    NSArray *sortKey = [data ls_allKeysSorted];

    BOOL containA = [data ls_containsObjectForKey:@"A"];
    BOOL containa = [data ls_containsObjectForKey:@"a"];
    BOOL containB = [data ls_containsObjectForKey:@"g"];

    XCTAssertNotNil(json);
    XCTAssertNotNil(dicDesc);
    XCTAssertEqual([dicDesc containsString:@"\\"], NO);
    XCTAssertEqual(sortKey.count > 0, YES);
    XCTAssertEqual(containA, NO);
    XCTAssertEqual(containB, NO);
    XCTAssertEqual(containa, YES);
}

- (void)testString {

    //检测首尾空格
    NSString *a = @" 测试空格  ";
    //检测中间空格是否会被去掉
    NSString *c = @" 测试  空格  ";
    //检测空字符串
    NSString *b = @"   ";

    NSString *val = [a ls_stringByTrim];
    NSString *valc = [c ls_stringByTrim];
    BOOL isB = [NSString ls_empty:b];

    XCTAssertEqual(isB, YES);
    XCTAssertEqual([val containsString:@" "], NO);
    XCTAssertEqual([valc containsString:@" "], YES);
}

- (void)testURLEncoding {

    NSString *url = @"http://aaaaa/aaa?key=测试&value=我的";

    NSString *urlEnc = [url ls_urlEncodedString];
    NSString *md5Enc = [url ls_md5EncodeString];
    NSString *urlDec = [urlEnc ls_urlDecodedString];

    XCTAssertNotNil(urlEnc);
    XCTAssertNotNil(urlDec);
    XCTAssertNotNil(md5Enc);
}

@end
