//
//  LSKITViewController.m
//  LSKit
//
//  Created by 542634994@qq.com on 09/29/2019.
//  Copyright (c) 2019 542634994@qq.com. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <LSKit/LSKit.h>


@protocol TestServiceProtocol <LSServiceProtocol>
- (void)test;

- (void)testReponseFailure1;
- (void)testReponseNext1;
- (void)testReponseSuccess1;

@end



LSDingKitService(TestServiceProtocol, TestService)
@interface TestService : LSService <TestServiceProtocol>

@end

@interface TestObj : NSObject

@property (nonatomic, assign) NSInteger testV;
@property (nonatomic, copy) NSString *testString;
@end

@implementation TestObj

-(void)test111{
    NSLog(@"创建服务");
    [self ls_CreateService:@protocol(TestServiceProtocol)];
}

-(void)dealloc{
    NSLog(@"释放了 %@",self.description);
}

@end

@implementation TestService

- (void)test {
    NSLog(@"测试");
}

- (void)testReponseNext1 {
    [self responseNext:@{ @"Next": @"value" }];
}

- (void)testReponseSuccess1 {
    [self responseSuccess:@{ @"Sucess": @"value" }];
}

- (void)testReponseFailure1 {
    NSError *error = [NSError errorWithDomain:@"-aaaaa--" code:1 userInfo:@{ @"Failire": @"value" }];
    [self responseFail:error];
}

@end

#import "LSKITViewController.h"

@interface LSKITViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) TestObj *ttTestObj;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<TestServiceProtocol> service;
@end

@implementation LSKITViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.ttTestObj = [TestObj new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];

    NSString *title = [self.dataSource objectAtIndex:indexPath.row];

    cell.textLabel.text = title;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [self.dataSource objectAtIndex:indexPath.row];

    if ([title isEqualToString:@"Toast-Bottom-default"]) {
        [self ls_toast:@"测试Toas提示框"];
    } else if ([title isEqualToString:@"Toast-Bottom-duration"]) {
        [self ls_toast:@"测试Toas提示框-5-5-5-55-5" duration:5];
    } else if ([title isEqualToString:@"Service"]) {
        self.service = [[[[self ls_CreateService:@protocol(TestServiceProtocol)] ls_subscribeNext:^(id _Nonnull value) {
            NSLog(@"ls_subscribeNext %@", value);
        }] ls_subscribeSuccess:^(id _Nonnull responseObject) {
            NSLog(@"ls_subscribeSuccess %@", responseObject);
        }] ls_subscribeFailure:^(NSError *_Nonnull error) {
            NSLog(@"ls_subscribeFailure %@", error);
        }];
        [self.service test];
    } else if ([title isEqualToString:@"Service Release"]) {
        [self ls_cancelService:self.service];
    } else if ([title isEqualToString:@"Service Next"]) {
        [self.service testReponseNext1];
    } else if ([title isEqualToString:@"Service Success"]) {
        [self.service testReponseSuccess1];
    } else if ([title isEqualToString:@"Service Failure"]) {
//        [self.service testReponseFailure1];
        TestObj *obj = [TestObj new];
        [obj test111];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];

        [_dataSource addObject:@"Toast-Bottom-default"];

        [_dataSource addObject:@"Toast-Bottom-duration"];
        [_dataSource addObject:@"Service"];
        [_dataSource addObject:@"Service Next"];
        [_dataSource addObject:@"Service Success"];
        [_dataSource addObject:@"Service Failure"];
        [_dataSource addObject:@"Service Release"];
    }

    return _dataSource;
}

- (IBAction)itemClick:(id)sender {
    self.ttTestObj.testString = @"1111";
}

- (IBAction)releaseSignal:(id)sender {
    NSLog(@"start : %@", [NSDate date]);
    [self.ttTestObj ls_sendSignal:@"testString1" values:@"testValue"];
}

- (IBAction)realseClick:(id)sender {
    self.ttTestObj = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
