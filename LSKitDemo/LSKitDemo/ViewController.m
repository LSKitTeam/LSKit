//
//  ViewController.m
//  LSKitDemo
//
//  Created by Lyson on 2018/4/5.
//  Copyright © 2018年 LSKitDemo. All rights reserved.
//

#import "ViewController.h"

#import <LSKit/LSKit.h>
@interface ViewController ()<LSMQTopicReceiveProtocol>

@end

@implementation ViewController

-(void)topicReceive:(id)msg topic:(NSString *)topic{
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//
//    NSString *url = @"测试 2018-12-1 abc";
//
//    NSString *urlCode = [url urlEncodedString];
//    NSLog(@"%@",urlCode);
//    NSLog(@"%@",[urlCode urlDecodedString]);
//    [[LSRouter sharedRouter] setNavigationController:self.navigationController];
//
//    [[LSRouter sharedRouter] map:@"TestViewController" toController:NSClassFromString(@"TestViewController")];
//
//    [[LSMQMessageListManager shareInstance] addTopic:(id<LSMQTopicReceiveProtocol>)self topic:@"test"];
//
//
//    [[LSMQMessageListManager shareInstance] addMsg:@"测试" topic:@"test"];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 70, 100, 100)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [[LSMQMessageListManager shareInstance] addTopic:(id<LSMQTopicReceiveProtocol>)self topic:@"test"];
}


-(void)btnClick{

    NSLog(@"1");
    for (int i = 0 ; i < 1000000; i++) {
        
        [[LSMQMessageListManager shareInstance] addMsg:@(i) topic:@"test"];
//        [datas addObject:@(i)];
    }
    NSLog(@"2");
    
//    [[LSRouter sharedRouter] open:@"TestViewController" animated:YES extraParams:@{@"key":@"value"} toCallback:^(NSDictionary *params) {
//
//        NSLog(@"回调参数 %@",params);
//    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
