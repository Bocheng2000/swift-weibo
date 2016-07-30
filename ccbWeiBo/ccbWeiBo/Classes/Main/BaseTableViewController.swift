//
//  BaseTableViewController.swift
//  ccbWeiBo
//
//  Created by 储诚波 on 16/7/2.
//  Copyright © 2016年 储诚波. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController,VisitorViewDelegate {
    
    //定义一个变量保存用户当前是否登录
    var userLogin:Bool = true
    //定义属性保存未登录界面
    var visitorView:VisitorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLogin ? super.loadView() : setupVisitorView()
    }
    
    /// 创建未登录界面
    private func setupVisitorView(){
        let customView = VisitorView()
//        customView.backgroundColor = UIColor.redColor()
        view = customView
        customView.delegate = self
        visitorView = customView
        
        //设置导航栏的登录按钮
//        navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "registerBtnWillClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "loginBtnWillClick")
        
    }
    
    func loginBtnWillClick() {
        print(__FUNCTION__)
    }

    func registerBtnWillClick() {
        print(__FUNCTION__)
    }

}
