//
//  UIButton+Category.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 15/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

extension UIButton{

    class func createButton(imageName:String, title:String)->UIButton{
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn

        
    
    }


}
