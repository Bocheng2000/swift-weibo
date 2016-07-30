//
//  AppDelegate.swift
//  ccbWeiBo
//
//  Created by 储诚波 on 16/7/1.
//  Copyright © 2016年 储诚波. All rights reserved.
//  测试分支3

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //设置导航条和工具条的外观
        //因为外观一旦设置全局有效,所以可以在程序一进来就设置所有的导航和tabbar的颜色,这样后续不用再每次都设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
        
        
        return true
    }

    
}

