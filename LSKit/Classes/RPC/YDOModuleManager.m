//
//  YDOModuleManager.m
//  Pods
//
//  Created by Lyson on 2019/4/11.
//

#import "YDOModuleManager.h"
#import "YDOContext.h"

#define YDOModuleManagerModuleName @"name"

#import "YDOModuleProtocol.h"

@interface YDOModuleManager ()

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *fordModuleInfos;
@property (nonatomic, strong) NSMutableArray<id<YDOModuleProtocol>> *fordModules;

@end

@implementation YDOModuleManager

+ (instancetype)shareInstance {

    static dispatch_once_t onceToken;
    static YDOModuleManager *_instance;

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

    _fordModules = [[NSMutableArray alloc] init];
    _fordModuleInfos = [[NSMutableArray alloc] init];
}

- (void)registerDynamicModule:(Class)cls {

    if (![cls conformsToProtocol:@protocol(YDOModuleProtocol)]) {
        return;
    }
    
    __block BOOL flag = YES;
    [self.fordModules enumerateObjectsUsingBlock:^(id<YDOModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isKindOfClass:cls]) {
            *stop = YES;
            flag = NO;
        }
        
    }];
    
    if (!flag) {
        return;
    }
    
    NSMutableDictionary *moduleInfo = [NSMutableDictionary dictionary];
    [moduleInfo setValue:cls forKey:YDOModuleManagerModuleName];
    
    [self.fordModuleInfos addObject:moduleInfo];
    
    id<YDOModuleProtocol> module = [[cls alloc] init];
    
    [self.fordModules addObject:module];
    
    if ([module respondsToSelector:@selector(ydoModuleDidRegister)]) {
        [module ydoModuleDidRegister];
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

    YDOContext *context = [YDOContext new];
    context.event = event;
    context.data = data;
    
    [self.fordModules enumerateObjectsUsingBlock:^(id<YDOModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        id<YDOModuleProtocol> target = obj;
        
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

- (void)triggerApplication:(UIApplication *)application
           didFinishLaunch:(NSDictionary *)launchOption {

    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:application,@"application",launchOption,@"launchOption", nil];
    
    YDOContext *context = [YDOContext new];
    context.event = @"0";
    context.data = para;
    
    [self.fordModules enumerateObjectsUsingBlock:^(id<YDOModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id<YDOModuleProtocol> target = obj;
        
        if ([target respondsToSelector:@selector(moduleApplicationFinishLaunch:)]) {
            [target moduleApplicationFinishLaunch:context];
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
