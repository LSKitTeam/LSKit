//
//  LSService.m
//  Pods
//
//  Created by Lyson on 2019/12/30.
//

#import "LSService.h"
#import "NSObject+LSService.h"
@interface LSService ()
@property (nonatomic, copy) void (^ nextBlock)(id value);
@property (nonatomic, copy) void (^ successBlock)(id responseObject);
@property (nonatomic, copy) void (^ failureBlock)(NSError *error);

@end

@implementation LSService

- (void)releaseService {
}

- (void)responseNext:(NSDictionary *)parameter {
    if (self.nextBlock) {
        self.nextBlock(parameter);
    }
}

- (void)responseFail:(NSError *)error {
    if (self.failureBlock) {
        self.failureBlock(error);
        [self releaseService];
        [self ls_cancelService:self];
    }
}

- (void)responseSuccess:(NSDictionary *)parameter {
    if (self.successBlock) {
        self.successBlock(parameter);
        [self releaseService];
        [self ls_cancelService:self];
    }
}

- (void)setCallbackNext:(void (^)(id value))next {
    self.nextBlock = next;
}

- (void)setCallbackSuccess:(void (^)(id responseObject))success {
    self.successBlock = success;
}

- (void)setCallbackFailure:(void (^)(NSError *error))failure {
    self.failureBlock = failure;
}

-(void)dealloc{
    NSLog(@"释放了 %@",self.description);
}


@end
