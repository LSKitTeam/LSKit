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

@interface LSKITViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) TestObj *ttTestObj;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = [self.dataSource objectAtIndex:indexPath.row];
    
    if ([title isEqualToString:@"Toast-Bottom-default"]) {
        
        [self ls_toast:@"测试Toas提示框"];
    }else if ([title isEqualToString:@"Toast-Bottom-duration"]) {
        
        [self ls_toast:@"测试Toas提示框-5-5-5-55-5" duration:5];
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
        
        [_dataSource addObject:@"Toast-Bottom-default"];
        
        [_dataSource addObject:@"Toast-Bottom-duration"];
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
