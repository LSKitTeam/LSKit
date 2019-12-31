//
//  LSService.h
//  Pods
//
//  Created by Lyson on 2019/12/30.
//

#import <Foundation/Foundation.h>
#import "LSServiceProtocol.h"

@interface LSService : NSObject <LSServiceProtocol>

- (void)responseNext:(NSDictionary *)parameter;

- (void)responseFail:(NSError *)error;

- (void)responseSuccess:(NSDictionary *)parameter;

- (void)setCallbackNext:(void (^)(id value))next;
- (void)setCallbackSuccess:(void (^)(id responseObject))success;
- (void)setCallbackFailure:(void (^)(NSError *error))failure;
                
@end
