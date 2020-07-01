//
//  ViewController.swift
//  HotFix_Swift
//
//  Created by JunMing on 2020/6/23.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let testClass = HFTestClass()
    private let arr = [
        ["title":"替换崩溃实例方法","sel":"instanceMethodCrashWithString:","js":"instanceMethodCrash","parames":""],
        ["title":"修改方法调用为其他方法","sel":"instanceReplaceWithString:","js":"instanceMethodReplace","parames":"我被替换了"],
        ["title":"修改参数","sel":"changePramesWithString:","js":"changePrames","parames":"😭😭😭我被改成了"],
        ["title":"调用方法","sel":"","js":"instanceRunMethod","parames":""],
        ["title":"前先调用Log方法","sel":"runBefore","js":"runMethodBefore","parames":"😁😁😁快看看我之前是否调用了Log方法"],
        ["title":"修改实例属性","sel":"setTest:","js":"changeproperty","parames":"🐶🐶🐱🐭🐭🐹"],
        ["title":"修改方法返回值","sel":"changeReturnValue","js":"changeReturn","parames":""]
    ]
    
    var dataSource = [Model]()
    lazy private var tableView:UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.estimatedRowHeight = 50
        tableView.separatorColor = view.backgroundColor
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.append(contentsOf: arr.map({ Model(title: $0["title"], sel: $0["sel"], parames: $0["parames"], jsfile: $0["js"]) }))
        view.addSubview(tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "RSBookCommentCell")
        if cell == nil { cell = UITableViewCell(style: .default, reuseIdentifier: "RSBookCommentCell") }
        cell?.textLabel?.text = dataSource[indexPath.row].title
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let jsName = dataSource[indexPath.row].jsfile else { return }
        guard let jsString = HFTool.jsFile(jsName: jsName) else { return }
        guard let sel = dataSource[indexPath.row].sel else { return }
        guard let parames = dataSource[indexPath.row].parames else { return }
        // 执行修复
        HFManager.evalString(jsString)
        
        // 调用方法，看是否修改
        let selector = NSSelectorFromString(sel)
        if testClass.responds(to: selector) {
            // print("\(HFTestClass.instancesRespond(to: selector) ? "😀😀😀响应了":"😭😭😭未响应")")
            testClass.perform(selector, with: parames)
        }

        if sel == "setTest:" {
            print("原来:\(parames),修改后:\(testClass.test)")
        }
        
        // 方法返回值
        print("方法返回值:\(testClass.changeReturnValue())")
    }
}

struct Model {
    var title:String?
    var sel:String?
    var parames:String?
    var jsfile:String?
}

extension NSObject {
    typealias AspectsBlock = (AspectInfo)->()
    func swift_hook(with sel: Selector, options: AspectOptions, usingBlock: @escaping AspectsBlock) throws {
        let blockObj: @convention(block) (_ id: AspectInfo)->Void = { aspectInfo in
            usingBlock(aspectInfo)
        }
        try self.aspect_hook(sel, with: options, usingBlock: blockObj)
    }
    
    static func swift_hook(with sel: Selector, options: AspectOptions, usingBlock: @escaping AspectsBlock) throws {
        let blockObj: @convention(block) (_ id: AspectInfo)->Void = { aspectInfo in
            usingBlock(aspectInfo)
        }
        try self.aspect_hook(sel, with: options, usingBlock: blockObj)
    }
}

//        do {
//            let newSEL = NSSelectorFromString("instanceMethodCrashWithString:")
//            try? testClass.swift_hook(with: newSEL, options: AspectOptions(rawValue: 2)) { (aspectInfo) in
//                print("😀😀😀我先执行")
//            }
//        }
