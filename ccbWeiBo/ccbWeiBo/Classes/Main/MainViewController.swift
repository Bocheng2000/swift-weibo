//
//  MainViewController.swift
//  ccbWeiBo
//
//  Created by 储诚波 on 16/7/1.
//  Copyright © 2016年 储诚波. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置当前控制对应的tabbar的颜色
        //注意:在ios7之前, 设置该属性只有文字会改变而图片颜色不会改变(此时选定图片,勾选到不给渲染)
//        tabBar.tintColor = UIColor.orangeColor()
        //添加所有子控制器
        addChirdViewControllers()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //添加+按钮
        setupComposeBtn()
    }
    
    private func setupComposeBtn()
    {
        //添加+
        tabBar.addSubview(composeBtn)
        //调整+号按钮的位置
        let width = UIScreen.mainScreen().bounds.size.width / CGFloat( viewControllers!.count)
        let rect = CGRect(x: 0, y: 0, width: width, height: 49)
        //参数一:frame的大小
        //参数二:x方向的偏移量
        //参数三:y方向的偏移量
        composeBtn.frame = CGRectOffset(rect, 2*width, 0)
        
    }
    
    //添加所有的自控制器
    private func addChirdViewControllers() {
        /*
         //1.创建首页
         let home = HomeTableViewController()
         //设置首页对应的tabbar对应的数据
         home.tabBarItem.image = UIImage(named: "tabbar_home")
         home.tabBarItem.selectedImage = UIImage(named: "tabbar_home_highlighted")
         
         home.title = "首页"
         
         //2给首页包装一个导航控制器
         let nav = UINavigationController()
         nav.addChildViewController(home)
         
         //将导航控制器带入当前控制器上
         addChildViewController(nav)
         */
        
        //1.获取json文件的路径
        let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        
        //2.通过该文件创建nsdata
        if let jsonPath = path {
            let jsonData = NSData(contentsOfFile: jsonPath)
            
            //处理异常代码模块
            do{//try    如果try后面发生异常,则会到catch中查找错误类型
                //try!  发生异常,则程序会直接崩溃
                let dictArr = try NSJSONSerialization.JSONObjectWithData(jsonData!, options:NSJSONReadingOptions.MutableContainers )
                print(dictArr)
                //3.序列化json数据->array
                //另:swift中遍历数组,必须明确遍历的数组的类型
                for dict in dictArr as![[String:String]] {
                    //此处报错是因为该方法中参数必须有值,而字典的返回值是可选类型,冲突.故要加!
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
                }
            }catch{
                print(error)
                addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
                addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
                //再添加一个占位控制器.用以显示中间的+
                addChildViewController("NullViewController", title: "", imageName: "")
                addChildViewController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
                addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
            }
        }
        
        //4.遍历数组动态创建控制器
        
        //将上述方法进行封装
        //        addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
        //        addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
        //        addChildViewController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
        //        addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
        
    }
    
    //封装私有方法来设置各个界面的属性
    //    private func addChildViewController(childController: UIViewController,title:String,imageName:String) {
    //
    //        print(childController)
    //
    //        childController.tabBarItem.image = UIImage(named: imageName)
    //        childController.tabBarItem.selectedImage = UIImage(named: imageName+"_highlighted")
    //
    //        childController.title = title
    //
    //        //2给首页包装一个导航控制器
    //        let nav = UINavigationController()
    //        nav.addChildViewController(childController)
    //        //将导航控制器添加到当前控制器上
    //        addChildViewController(nav)
    //        
    //    }

    
    //通过字符创string来初始化类和加载
    private func addChildViewController(childControllerName: String,title:String,imageName:String) {
        
        //1.将字符串转换为类
        //默认的项目命名空间一般为项目名称.但是可以修改.因此应该动态的获取命名空间
        let ns = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String//获取动态的命名空间
        //swift中在转换类时需要加上项目命名空间  重要
        let cls:AnyClass? = NSClassFromString(ns+"."+childControllerName)!
        
        //2.通过类创建对象
        //2.1将anyclass转换为指定类型
        let vcCls = cls as! UIViewController.Type
        let vc = vcCls.init()
        
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName+"_highlighted")
        
        vc.title = title
        
        //2给首页包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        //将导航控制器添加到当前控制器上
        addChildViewController(nav)
        print(vc)
    }
    
    //懒加载中间的+     
    //懒加载必须要有var
    private lazy var composeBtn:UIButton = {
        let btn = UIButton()
        //设置前景图片
        btn.setImage(UIImage(named:"tabbar_compose_icon_add" ), forState: UIControlState.Normal)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        //设置背景图片
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        //添加监听
        btn.addTarget(self, action: "composeBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
    
    /**
     监听方法不可设置为私有方法.设置私有方法时会崩溃
     */
    func composeBtnClick()
    {
        
        print(__FUNCTION__)
    }
}