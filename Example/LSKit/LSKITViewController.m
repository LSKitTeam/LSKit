//
//  LSKITViewController.m
//  LSKit
//
//  Created by 542634994@qq.com on 09/29/2019.
//  Copyright (c) 2019 542634994@qq.com. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <LSKit/LSKit.h>
@interface TestObj : NSObject

@property (nonatomic, assign) NSInteger testV;
@property (nonatomic, copy) NSString *testString;
@end

@implementation TestObj


@end

#import "LSKITViewController.h"

@interface LSKITViewController ()

@property (nonatomic, strong) TestObj *ttTestObj;
@end

@implementation LSKITViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ttTestObj = [TestObj new];
    
    [[self.ttTestObj ls_valuesForKeyPath:@"testString"] subscribe:^(id value) {
//        NSLog(@"end : %@",[NSDate date]);
        NSLog(@"change value : %@",value);
    }];
    
    [[self.ttTestObj ls_valuesForGlobalKeyPath:@"testString"] subscribe:^(id value) {
        NSLog(@"topic value1 : %@",value);
    }];
    
    [[self.ttTestObj ls_valuesForGlobalKeyPath:@"testString"] subscribe:^(id value) {
        NSLog(@"topic value2 : %@",value);
    }];
    
    
    [[self ls_valuesForGlobalKeyPath:@"testString"] subscribe:^(id value) {
        NSLog(@"topic value3 : %@",value);
    }];
    
    [[self.ttTestObj ls_valuesForGlobalKeyPath:@"testString1"] subscribe:^(id value) {
        NSLog(@"end : %@",[NSDate date]);
        NSLog(@"topic value4 : %@",value);
    }];
    
    self.ttTestObj.testString = @"22222";
	// Do any additional setup after loading the view, typically from a nib.
}


-(IBAction)itemClick:(id)sender{
    
    
    self.ttTestObj.testString = @"1111";
}


-(IBAction)releaseSignal:(id)sender{
    
    NSLog(@"start : %@",[NSDate date]);
    [self.ttTestObj ls_sendSignal:@"testString1" values:@"testValue"];
}

-(IBAction)realseClick:(id)sender{
    
    self.ttTestObj = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
