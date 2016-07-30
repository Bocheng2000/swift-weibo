//
//  VisitorView.swift
//  ccbWeiBo
//
//  Created by 储诚波 on 16/7/2.
//  Copyright © 2016年 储诚波. All rights reserved.
//

import UIKit

//SWIFT中定义协议,必须遵守nsobjectProtocol
protocol VisitorViewDelegate:NSObjectProtocol{
    //登录的回调
    func loginBtnWillClick()
    //注册的回调
    func registerBtnWillClick()
}

class VisitorView: UIView {
    
    //定义一个属性保存代理对象---一定要加上weak,避免循环引用
    weak var delegate:VisitorViewDelegate?
    
    /**
     设置未登录界面判断
     
     - parameter isHome:    是否是首页
     - parameter imageName: 需要展示的图标名称
     - parameter message:   需要展示的消息
     */
    func setupVisitorInfo(isHome:Bool,imageName:String,message:String) {
        //如果不是首页,就隐藏转盘.
        iconView.hidden = !isHome
        //修改中间图标
        homeIocn.image = UIImage(named: imageName)
        //修改文本
        messageLabel.text = message
        
        //判断是否需要执行动画.只有首页才有动画
        if isHome {
            startAnimatin()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //1.添加子控件
        addSubview(iconView)
        addSubview(maskBGview)//注意:添加控件的顺序.会影响控件之间的遮盖
        addSubview(homeIocn)
        
        addSubview(messageLabel)
        addSubview(loginButton)
        addSubview(registerButton)
        //2.布局子控件
        //2.1设置背景---导入的小马哥的自动布局tools
        iconView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        //2.2设置小房子
        //设置蒙版
        maskBGview.xmg_Fill(self)
        homeIocn.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        //2.3设置label文字
        messageLabel.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: iconView, size: nil)
        //设置约束
        /// "哪个控件" 的 "什么属性"  "等于" "另外一个控件" 的 "什么属性" "*" " 倍数" "+" "多少"
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224))
        
        //2.4设置登录注册按钮
        registerButton.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: messageLabel, size: CGSize(width: 100,height: 30), offset: CGPoint(x: 0, y: 20))
        loginButton.xmg_AlignVertical(type: XMG_AlignType.BottomRight, referView: messageLabel, size: CGSize(width: 100,height: 30), offset: CGPoint(x: 0, y: 20))
        
        
    }
    
    //swift强制要求:如果要自定义控件时,要么用纯代码  要么用xib/storyboard
    //swift推荐我们自定义一个控件时..要么用纯代码.要么用xib/storyboard
    required init?(coder aDecoder: NSCoder) {
        //此行代码表示,要是通过xib/storyboard创建控件时,那么该方法会崩溃
        fatalError("init(coder:) has not been implemented")
    }

    //MARK -懒加载
    /// 转盘图标
    private lazy var iconView :UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return iv
        
    }()
    
    //设置首页动画
    private func startAnimatin(){
        //1.创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        //2.设置动画属性
        anim.toValue = 2*M_PI
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        anim.removedOnCompletion = false//该属性默认为yes,代表动画只要执行完毕就移除
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    
    //图标
    private lazy var homeIocn:UIImageView = {
        let iv = UIImageView(image:UIImage(named:"visitordiscover_feed_image_house"))
        return iv
    }()
    
    //文本
    private lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.text = "关注一些人.回这里看看有什么惊喜"
        label.sizeToFit()
        label.numberOfLines = 0
        label.textColor = UIColor.darkGrayColor()
        return label
    }()
    
    //登录按钮
    private lazy var loginButton : UIButton = {
       let btn = UIButton()
        btn.setTitle("登录", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "clickLoginBtn", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    //注册按钮
    private lazy var registerButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "clickRegisterBtn", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    //挡住部分颜色
    private lazy var maskBGview:UIImageView = {
        let  iv = UIImageView (image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return iv
    }()
    
    func clickLoginBtn() {
//        print(__FUNCTION__)
        delegate?.loginBtnWillClick()
    }
    
    func clickRegisterBtn() {
//        print(__FUNCTION__)
        delegate?.registerBtnWillClick()
    }
    
}
