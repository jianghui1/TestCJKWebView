//
//  ViewController.swift
//  TestCJKWebView
//
//  Created by ys on 15/12/30.
//  Copyright © 2015年 ys. All rights reserved.
//  测试webview

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let button: UIButton = UIButton(type: UIButtonType.System)
        button.frame = CGRectMake(100, 100, 100, 30)
        button.backgroundColor = UIColor.redColor()
        button.addTarget(self, action: #selector(ViewController.buttonAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func buttonAction() {
        self.navigationController?.pushViewController(CJWKWebBrowserViewController(), animated: true)
    }
}

