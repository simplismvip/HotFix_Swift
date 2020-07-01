//
//  HFManager.m
//  HotFix
//
//  Created by JunMing on 2020/6/22.
//  Copyright © 2020 JunMing. All rights reserved.
//

#import "HFManager.h"
#import "NSInvocation+HFAddtion.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIGeometry.h>
#import "Aspects.h"
#import "HotFix_Swift-Swift.h"

@implementation HFManager
+ (JSContext *)context {
    static JSContext *context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[JSContext alloc] init];
    });
    return context;
}

+ (void)FixRun {
    JSContext *context = [self context];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"🆘🆘🆘 异常 🆘🆘🆘");
    };
    context[@"runError"] = ^(NSString *instanceName, NSString *selectorName) {
        NSLog(@"😭😭😭: 类%@的%@方法未实现", instanceName, selectorName);
    };
    
    context[@"fixMethod"] = ^(NSString *className, NSString *selectorName, AspectOptions options, JSValue *fixImp) {
        [self fixWithClassName:className opthios:options selector:selectorName fixImp:fixImp];
    };
    
    context[@"runInvocation"] = ^(NSString * className, NSString *selectorName, id arguments) {
        id obj = [self runWithClassname:className selector:selectorName arguments:arguments];
        if (obj) { NSLog(@"%@",obj); }
    };
    
    // 运行方法
    context[@"runMethod"] = ^id(NSString * className, NSString *selectorName, id arguments) {
        id obj = [self runWithClassname:className selector:selectorName arguments:arguments];
        if (obj) { NSLog(@"%@",obj); }
        return obj;
    };
    
    // 修改方法参数
    context[@"setInvocationArguments"] = ^(NSInvocation *invocation, id arguments) {
        if ([arguments isKindOfClass:[NSArray class]]) {
            invocation.arguments = arguments;
        }else {
            [invocation setMyArgument:arguments atIndex:0];
        }
    };
    
    // 修改setter属性
    context[@"changeproperty"] = ^(NSInvocation *invocation, id arguments) {
        if ([arguments isKindOfClass:[NSArray class]]) {
            invocation.arguments = arguments;
        }else {
            [invocation setMyArgument:arguments atIndex:0];
        }
    };
    
    // 修改方法的返回值
    context[@"changeReturnValue"] = ^(id instance, NSInvocation *invocation, id arguments) {
        NSLog(@"%@",[invocation returnValue_obj]);
        [invocation setReturnValue_obj:arguments];
        NSLog(@"%@",[invocation returnValue_obj]);
    };
}

+ (id)evalString:(NSString *)jsString {
    if (jsString == nil || jsString == (id)[NSNull null] || [NSString isKindOfClass:[NSString class]]) { return nil; }
    JSValue *jsValue = [[self context] evaluateScript:jsString];
    if (jsValue.toObject) {
        return jsValue.toObject;
    }else {
        return nil;
    }
}

+ (void)fixWithClassName:(NSString *)className opthios:(AspectOptions)options selector:(NSString *)selector fixImp:(JSValue *)fixImp {
    Class cla = NSClassFromString(className);
    SEL sel = NSSelectorFromString(selector);
    
//    HFTestClass *class = [[HFTestClass alloc] init];
//    class.test = @"sdddsfdfgfdgdhfgh";
//    NSLog(@"%@", class.test);
//    [self printMothListWithObj:class];
    if ([cla instancesRespondToSelector:sel]) {
        NSLog(@"🐶🐶🐶");
    } else if ([cla respondsToSelector:sel]){
        cla = object_getClass(cla);
    } else {
        return;
    }
    
    [cla aspect_hookSelector:sel withOptions:options usingBlock:^(id<AspectInfo> aspectInfo) {
        NSMutableArray *arr = [NSMutableArray array];
        if (aspectInfo.instance) {
            [arr addObject:aspectInfo.instance];
        } else {
            [arr addObject:[NSNull null]];
        }
        if (aspectInfo.originalInvocation) {
            [arr addObject:aspectInfo.originalInvocation];
        } else {
            [arr addObject:[NSNull null]];
        }
        if (aspectInfo.arguments) {
            [arr addObject:aspectInfo.arguments];
        } else {
            [arr addObject:[NSNull null]];
        }
        [fixImp callWithArguments:arr];
    } error:nil];
}

+ (id)runWithInstance:(id)instance selector:(NSString *)selector arguments:(NSArray *)arguments {
    if (!instance) { return nil; }
    if (arguments && [arguments isKindOfClass:NSArray.class] == NO) {
        arguments = @[arguments];
    }
    SEL sel = NSSelectorFromString(selector);

    if ([instance isKindOfClass:JSValue.class]) {
        instance = [instance toObject];
    }
    NSMethodSignature *signature = [instance methodSignatureForSelector:sel];
    if (!signature) { return nil; }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = sel;
    invocation.arguments = arguments;
    [invocation invokeWithTarget:instance];
    return invocation.returnValue_obj;
}

+ (id)runWithClassname:(NSString *)className selector:(NSString *)selector arguments:(NSArray *)arguments {
    Class cla = NSClassFromString(className);
    SEL sel = NSSelectorFromString(selector);
    if (arguments && [arguments isKindOfClass:NSArray.class] == NO) {
        arguments = @[arguments];
    }
    if ([cla instancesRespondToSelector:sel]) {
        id instance = [[cla alloc] init];
        NSMethodSignature *signature = [instance methodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector = sel;
        invocation.arguments = arguments;
        [invocation invokeWithTarget:instance];
        return invocation.returnValue_obj;
    } else if ([cla respondsToSelector:sel]){
        NSMethodSignature *signature = [cla methodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector = sel;
        invocation.arguments = arguments;
        [invocation invokeWithTarget:cla];
        return invocation.returnValue_obj;
    } else {
        return nil;
    }
}

+ (void)printMothListWithObj:(id)obj {
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList([obj class], &mothCout_f);
    for (int i = 0; i < mothCout_f; i ++) {
        Method temp_f = mothList_f[i];
        IMP imp_f = method_getImplementation(temp_f);
        SEL name_f = method_getName(temp_f);
        const char *name_s = sel_getName(method_getName(temp_f));
        int arguments = method_getNumberOfArguments(temp_f);
        const char *encoding = method_getTypeEncoding(temp_f);

        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s], arguments, [NSString stringWithUTF8String:encoding]);
    }

    free(mothList_f);
}

@end
