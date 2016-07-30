//
//  HomeTableViewController.swift
//  ccbWeiBo
//
//  Created by 储诚波 on 16/7/1.
//  Copyright © 2016年 储诚波. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //1.如果没有登录.就设置未登录界面信息
        if !userLogin {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人,回这里看看有什么惊喜")
            
        }
        
        //2.初始化导航条
        setupNav()
        
        //3.注册通知 监听菜单
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.change), name: ccbPopoveraAnimationWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.change), name: ccbPopoveraAnimationWillDismiss, object: nil)

    
    }
    
    func change() {
        let titleBtn = navigationItem.titleView as! TitleButton
        titleBtn.selected = !titleBtn.selected
    }
    
    //由于设置了监听通知  必须要移除通知
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    private func setupNav()
    {
        /*封装第一次,在本类的下面添加方法
        //左边按钮
        let leftBt = UIButton()
        leftBt.setImage(UIImage(named:"navigationbar_friendattention"), forState: UIControlState.Normal)
        leftBt.setImage(UIImage(named: "navigationbar_friendattention_highlighted"), forState: UIControlState.Highlighted)
        leftBt.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBt)
        
        //右边按钮
        let rightBt = UIButton()
        rightBt.setImage(UIImage(named:"navigationbar_pop"), forState: UIControlState.Normal)
        rightBt.setImage(UIImage(named: "navigationbar_pop_highlighted"), forState: UIControlState.Highlighted)
        rightBt.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBt)
        */
        
        /**
         封装第二次,直接将下述方法在扩展中实现UIBarButtonItem+Catagory
         
         - parameter target: <#target description#>
         - parameter action: <#action description#>
         */
//        navigationItem.leftBarButtonItem = createBarButtonItem("navigationbar_friendattention", target: self, action: "leftItemClick")
//        navigationItem.rightBarButtonItem = createBarButtonItem("navigationbar_pop", target: self, action: "rightItemClick")
//
        //初始化左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: "leftItemClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: "rightItemClick")
        
        //初始化标题按钮
        let titleBtn = TitleButton()
        //下面注释代码在titlebutton中实现,有利于将控制器和view进行解耦.
//        titleBtn.sizeToFit()
//        titleBtn.setTitle("精彩人生",forState:UIControlState.Normal)
//        titleBtn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
//        titleBtn.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
//        titleBtn.setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        titleBtn.addTarget(self, action: "titleBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        navigationItem.titleView = titleBtn
        
    }
//
//   
//    
//    
    func titleBtnClick(btn:UIButton){
        //1.修改箭头的方向
//        btn.selected = !btn.selected//设置了监听方法,该语句失效
        //2.弹出菜单
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        //2.1设置转场代理
        //默认情况下,modal会移除以前控制器的view,替换为当前弹出的view,如果自定义转场,则不会移除以前控制器的view
//        vc?.transitioningDelegate = self//利用自身的方法来 负责转场
        vc!.transitioningDelegate = popoverAnimator//封装单独的类来负责转场
        //2.2设置转场样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    func leftItemClick()
    {
        print(__FUNCTION__)
    }
    
    func rightItemClick()
    {
        print(__FUNCTION__)
    }
    
    //懒加载
    //一定要定义一个属性来保存自定义转对象  否则会报错
    private lazy var popoverAnimator:PopoverAnimator = {
        let pa = PopoverAnimator()
        pa.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return pa
    }()
    //第一次记得封装重复代码
    /*第二次扩展.在UIBarButtonItem+Catagory中直接扩展UIBarButtonItem的方法,可以方便的在每次重复调用的时候直接使用,  不用每次都封装
    private func createBarButtonItem(imageName:String,target:AnyObject?,action:Selector)->UIBarButtonItem
    {
        let Bt = UIButton()
        Bt.setImage(UIImage(named:imageName), forState: UIControlState.Normal)
        Bt.setImage(UIImage(named: imageName+"_highlighted"), forState: UIControlState.Highlighted)
        Bt.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        Bt.sizeToFit()
        return UIBarButtonItem(customView: Bt)
    }
 */
    
    //记录当前是否为展开状态
    var isPresent:Bool = false
}

extension HomeTableViewController:UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning{
    
    //实现代理,告诉系统谁来负责转场动画
    //下述即为自定义转场动画方法
    //UIPresentationController  iOS8推出的专门负责转场动画的
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        return PopoverUIPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    //控制视图出现和消失的动画 遵循协议UIViewControllerAnimatedTransitioning,实现对应的方法
    
    /**
     告诉系统谁来负责modal的展现动画
     
     - parameter presented:  被展现视图
     - parameter presenting: 发起的视图
     
     - returns: 谁爱负责
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = true
        return self
    }
    
    /**
     告诉系统谁来负责modal的显示动画
     
     - parameter dismissed: 被关闭的视图
     
     - returns: 谁来负责
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = false
        return self
    }
    
    //只要实现了下面的两个方法,那么系统就不会控制视图的加载和消失动画了.系统的默认动画都没了. 所有的操作都需要程序员来完成
    
    /**
     返回动画时长
     
     - parameter transitionContext: 上下文,里面保存了动画需要的所有参数
     
     - returns: 动画时长
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.5
    }
    
    /**
     告诉系统如何动画
     
     - parameter transitionContext: 上下文,里面保存了动画需要的所有参数
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        /*
        //1.拿视图
        let toVC =  transitionContext.viewControllerForKey(UITransitionContextToViewKey)
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewKey)
        print(toVC)
        print(fromVC)
        //通过打印看出 需要修改的到底是from还是to vc
        */
        
        if isPresent {
            //展开
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
            toView?.transform = CGAffineTransformMakeScale(1.0, 0.0)
            //注意:一定要将视图添加到容器上
            transitionContext.containerView()?.addSubview(toView!)
            //设置锚点(视图动画开始的点,默认在中间位置)
            toView?.layer.anchorPoint = CGPointMake(0.5, 0)
            //2.执行动画
            UIView.animateWithDuration(0.5, animations: {
                toView?.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                //2.2动画执行完毕,一定要告诉系统,
                //一定要写,如果不写可能导致一些未知的错误,不报错就是得不到正确结果
                transitionContext.completeTransition(true)
            }
        }else
        {
            //关闭
            print("关闭")
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            UIView.animateWithDuration(0.2, animations: {() -> Void in
                //注意:由于cgfloat是不准确的.所以写0.0会没有动画
                //压扁
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.000001)
                }, completion: { (_)->Void in
                    transitionContext.completeTransition(true)
            })
        }
        
    }
}



