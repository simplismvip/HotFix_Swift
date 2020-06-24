//
//  HFTool.swift
//  HotFix_Swift
//
//  Created by JunMing on 2020/6/23.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit

class HFTool {
    static func jsFile(jsName:String) -> String? {
        guard let path = Bundle.main.path(forResource: jsName, ofType: "js") else { return nil }
        guard let jsString = try? String(contentsOfFile: path, encoding: .utf8) else { return nil }
        return jsString
    }
}

@objc(HFTestClass)
@objcMembers class HFTestClass: NSObject {
    /// 这两个方法参数传空会崩溃,修复闪退
    func instanceMethodCrash(string:String?) {
        var str = [String]()
        str.append(string!)
        print("😭😭😭instanceMethodCrash--\(string ?? "null")")
    }
    
    func instanceMethodCrashReplace() {
        print("instanceMethodCrash--会崩溃，替换到我(instanceMethodCrashReplace)这里来了😀😀😀")
    }
    
    /// 替换方法，调用这个方法实际上会调用 replaceLog:这个方法
    func instanceReplace(string:String?) {
        print("😭😭😭instanceReplace--\(string ?? "null")")
    }
    
    func replaceLog(string:String?) ->String {
        print("instanceReplace--被替换成我(replaceLog)了！😀😀😀")
        return "😃😃😃替换方法成功"
    }
    
    /// 修改参数
    func changePrames(string:String?) {
        print("\(string ?? "null"):changePrames--")
    }
    
    /// js调用运行方法
    func runMethod(string:String?) {
        print("\(string ?? "null"):runMethod--")
    }
    
    /// 调用这个方法之前回调用log的哦
    func runBefore() {
        print("快看看我之前是否运行了log方法:runBefore--")
    }
    
    func log(string:String?) {
        print("😃😃😃我是Log方法🥰🥰🥰")
    }
}
