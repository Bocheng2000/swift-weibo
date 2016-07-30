//
//  PopoverUIPresentationController.swift
//  ccbWeiBo
//
//  Created by 储诚波 on 16/7/4.
//  Copyright © 2016年 储诚波. All rights reserved.
//

import UIKit

class PopoverUIPresentationController: UIPresentationController {
    
    //定义属性保存菜单的大小
    var presentFrame = CGRectZero
    
    /**
     初始化方法,用于创建负责转场动画的对象
     
     - parameter presentedViewController:  被展现的控制器
     - parameter presentingViewController: 发起的控制器,xcode6是nil,xcode7是野指针
     
     - returns: 负责转场动画的对象
     */
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        print(presentedViewController)
//        print(presentingViewController)
    }
    
    /**
     即将布局转场展现子视图调用
     */
    override func containerViewWillLayoutSubviews() {
        //1.修改弹出视图的大小
//        containerView容器
        //presentview被展现的视图
        // 1.修改弹出视图的大小
        if presentFrame == CGRectZero{
            
            presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        }else
        {
            presentedView()?.frame = presentFrame
        }

        
        //2.在容器仕途上添加一个蒙版,插入到展现视图的下面
        //因为展现视图和蒙版都在同一个视图上,而后添加的会盖住先添加的
        containerView?.insertSubview(coreView, atIndex: 0)
    }
    
    //MARK---懒加载蒙版view
    private lazy var coreView: UIView = {
        //1.创建view
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        
        //2.添加监听
        let tap = UITapGestureRecognizer(target: self, action: "close")
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    func close() {
        //presentedViewController拿到当前的控制器
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
