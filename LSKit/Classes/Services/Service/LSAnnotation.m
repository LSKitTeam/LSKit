//
//  FDAnnotation.m
//  Pods
//
//  Created by Lyson on 2019/4/11.
//

#import "LSAnnotation.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <mach-o/ldsyms.h>

#import "LSModuleManager.h"
#import "LSServiceManager.h"

NSArray<NSString *> * LSReadConfiguration(char *sectionName, const struct mach_header *mhp);

static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide)
{
    NSArray *mods = LSReadConfiguration(LSDingKitModName, mhp);
    for (NSString *modName in mods) {
        Class cls;
        if (modName) {
            cls = NSClassFromString(modName);
            if (cls) [[LSModuleManager shareInstance] registerDynamicModule:cls];
        }
    }

    NSArray *services = LSReadConfiguration(LSDingKitServiceName, mhp);
    for (NSString *serviceName in services) {
        if (serviceName) {
            NSData *jsonData =  [serviceName dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
            if (!error) {
                if ([json isKindOfClass:[NSDictionary class]] && [json allKeys].count) {
                    NSString *proName = [json allKeys][0];
                    NSString *clsName = [json allValues][0];

                    Class cls = NSClassFromString(clsName);
                    Protocol *pro = NSProtocolFromString(proName);
                    [[LSServiceManager shareInstance] registerDynamicService:pro impl:cls];
                }
            }
        }
    }
}

__attribute__((constructor))
void initPlugin()
{
    _dyld_register_func_for_add_image(dyld_callback);
}

NSArray<NSString *> * LSReadConfiguration(char *sectionName, const struct mach_header *mhp)
{
    NSMutableArray *configs = [NSMutableArray array];
    unsigned long size = 0;
#ifndef __LP64__
    uintptr_t *memory = (uintptr_t *)getsectiondata(mhp, SEG_DATA, sectionName, &size);
#else
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp;
    uintptr_t *memory = (uintptr_t *)getsectiondata(mhp64, SEG_DATA, sectionName, &size);
#endif

    unsigned long counter = size / sizeof(void *);
    for (int idx = 0; idx < counter; ++idx) {
        char *string = (char *)memory[idx];
        NSString *str = [NSString stringWithUTF8String:string];
        if (!str) continue;
        if (str) [configs addObject:str];
    }

    return configs;
}

@implementation LSAnnotation
@end
