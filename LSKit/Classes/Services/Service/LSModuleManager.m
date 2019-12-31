//
//  YDOModuleManager.m
//  Pods
//
//  Created by Lyson on 2019/4/11.
//

#import "LSModuleManager.h"
#import "LSContext.h"
#import "LSModuleProtocol.h"

#define LSModuleManagerModuleName @"name"



@interface LSModuleManager ()

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *lsModuleInfos;
@property (nonatomic, strong) NSMutableArray<id<LSModuleProtocol>> *lsModules;

@end

@implementation LSModuleManager

+ (instancetype)shareInstance {

    static dispatch_once_t onceToken;
    static LSModuleManager *_instance;

    dispatch_once(&onceToken, ^{

        _instance = [self new];
    });

    return _instance;
}

- (instancetype)init {

    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)initData {

    _lsModules = [[NSMutableArray alloc] init];
    _lsModuleInfos = [[NSMutableArray alloc] init];
}

- (void)registerDynamicModule:(Class)cls {

    if (![cls conformsToProtocol:@protocol(LSModuleProtocol)]) {
        return;
    }
    
    __block BOOL flag = YES;
    [self.lsModules enumerateObjectsUsingBlock:^(id<LSModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isKindOfClass:cls]) {
            *stop = YES;
            flag = NO;
        }
        
    }];
    
    if (!flag) {
        return;
    }
    
    NSMutableDictionary *moduleInfo = [NSMutableDictionary dictionary];
    [moduleInfo setValue:cls forKey:LSModuleManagerModuleName];
    
    [self.lsModuleInfos addObject:moduleInfo];
    
    id<LSModuleProtocol> module = [[cls alloc] init];
    
    [self.lsModules addObject:module];
    
    if ([module respondsToSelector:@selector(lsModuleDidRegister)]) {
        [module lsModuleDidRegister];
    }

}

- (void)triggerCustomModule:(NSString *)event data:(NSDictionary *)data {

    NSArray *eventFortmat = [event componentsSeparatedByString:@":"];

    NSString *moduleName = nil;
    NSString *moduleAction = nil;
    if (eventFortmat.count == 2) {
        moduleName = eventFortmat.firstObject;
        moduleAction = eventFortmat.lastObject;
    }

    LSContext *context = [LSContext new];
    context.event = event;
    context.data = data;
    
    [self.lsModules enumerateObjectsUsingBlock:^(id<LSModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        id<LSModuleProtocol> target = obj;
        
        BOOL continueFlag = YES;
        
        if ([target respondsToSelector:@selector(customeSubscribeModule)]) {
            
            NSArray *moudles = [target customeSubscribeModule];
            if ([self checkSubscribeModule:moudles module:moduleName]) {
                continueFlag = YES;
            }else{
                continueFlag = NO;
            }
        }
        
        if ([target respondsToSelector:@selector(customeSubscribeActions)] && continueFlag) {
            
            NSArray *actions = [target customeSubscribeActions];
            
            if ([self checkSubscribeActions:actions module:moduleAction]
                ) {
                continueFlag = YES;
            }else{
                continueFlag = NO;
            }
        }
        
        if ([target respondsToSelector:@selector(moduleCustomEvent:)] && continueFlag) {
            [target moduleCustomEvent:context];
        }
        
    }];
}

- (BOOL)checkSubscribeActions:(NSArray *)actions module:(NSString *)action {

    __block BOOL result = NO;
    [actions enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx,
                                          BOOL *_Nonnull stop) {

        if ([obj isEqualToString:action]) {

            result = YES;
            *stop = YES;
        }

    }];

    return result;
}

- (BOOL)checkSubscribeModule:(NSArray *)modules module:(NSString *)module {
    __block BOOL result = NO;
    [modules enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:module]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

@end
