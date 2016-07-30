//
//  TitleButton.swift
//  ccbWeiBo
//
//  Created by 储诚波 on 16/7/3.
//  Copyright © 2016年 储诚波. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sizeToFit()
        setTitle("精彩人生 ",forState:UIControlState.Normal)
        setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        titleLabel?.frame.offsetInPlace(dx: -imageView!.bounds.width*0.5, dy: 0)
//        imageView?.frame.offsetInPlace(dx: titleLabel!.bounds.width*0.5, dy: 0)
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.size.width
    }

}
