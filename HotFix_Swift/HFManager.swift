//
//  HFManager.swift
//  HotFix_Swift
//
//  Created by JunMing on 2020/6/23.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import JavaScriptCore

/*
 
 context[@"runError"] = ^(NSString *instanceName, NSString *selectorName) {
     NSLog(@"😭😭😭: 类%@的%@方法未实现", instanceName, selectorName);
 };
 
 context[@"fixMethod"] = ^(NSString *className, NSString *selectorName, AspectOptions options, JSValue *fixImp) {
     [self fixWithClassName:className opthios:options selector:selectorName fixImp:fixImp];
 };
 
 context[@"runMethod"] = ^id(NSString * className, NSString *selectorName, id arguments) {
     id obj = [self runWithClassname:className selector:selectorName arguments:arguments];
     if (obj) { NSLog(@"%@",obj); }
     return obj;
 };
 
 context[@"setInvocationArguments"] = ^(NSInvocation *invocation, id arguments) {
     if ([arguments isKindOfClass:[NSArray class]]) {
         invocation.arguments = arguments;
     }else {
         [invocation setMyArgument:arguments atIndex:0];
     }
 };
 */

protocol HotFixDelagate:JSExport {
//    func runError(instanceName:String,selectorName:String)
//    func fixMethod(instanceName:String,selectorName:String)
//    func runMethod(instanceName:String,selectorName:String)
//    func setInvocationArguments(invocation:NSInvocation,selectorName:String)
}

class HotFixManager: NSObject {
    static let context = JSContext()
    static func FixRun() {
        let content = HFManager.context
//        context("runError") = ""
        
    }
}
