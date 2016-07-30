//
//  PopoverAnimator.swift
//  ccbWeiBo
//
//  Created by 储诚波 on 16/7/9.
//  Copyright © 2016年 储诚波. All rights reserved.
//

import UIKit

//定义常量保存通知!通知来改变箭头的方向
let ccbPopoveraAnimationWillShow = "ccbPopoveraAnimationWillShow"
let ccbPopoveraAnimationWillDismiss = "ccbPopoveraAnimationWillDismiss"

class PopoverAnimator: NSObject,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning{
    
    //记录当前是否为展开状态
    var isPresent:Bool = false
    var presentFrame = CGRectZero
    
    //实现代理,告诉系统谁来负责转场动画
    //下述即为自定义转场动画方法
    //UIPresentationController  iOS8推出的专门负责转场动画的
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        let pc = PopoverUIPresentationController(presentedViewController: presented, presentingViewController: presenting)
        //设置菜单的大小
        pc.presentFrame = presentFrame
        return pc
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
        //发送通知,通知控制器即将展开
        NSNotificationCenter.defaultCenter().postNotificationName("ccbPopoveraAnimationWillShow", object: self)
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
        NSNotificationCenter.defaultCenter().postNotificationName("ccbPopoveraAnimationWillDismiss", object: self)
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
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
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
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {() -> Void in
                //注意:由于cgfloat是不准确的.所以写0.0会没有动画
                //压扁
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.000001)
                }, completion: { (_)->Void in
                    transitionContext.completeTransition(true)
            })
        }
        
    }
}

