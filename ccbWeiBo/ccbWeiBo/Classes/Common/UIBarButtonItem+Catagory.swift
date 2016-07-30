//
//  UIBarButtonItem+Catagory.swift
//  ccbWeiBo
//
//  Created by 储诚波 on 16/7/3.
//  Copyright © 2016年 储诚波. All rights reserved.
//

//增加分类.给按钮扩展方法
//在swift中选择的是 swift.file文件.名字是 要封装的方法名加上category
import UIKit

extension UIBarButtonItem{
    //如果在func前面加上class,就相当于oc中的+
    class func createBarButtonItem(imageName:String,target:AnyObject?,action:Selector)->UIBarButtonItem{
            let Bt = UIButton()
        Bt.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            Bt.setImage(UIImage(named:imageName), forState: UIControlState.Normal)
            Bt.setImage(UIImage(named: imageName+"_highlighted"), forState: UIControlState.Highlighted)
            Bt.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
            Bt.sizeToFit()
            return UIBarButtonItem(customView: Bt)
    }
}
