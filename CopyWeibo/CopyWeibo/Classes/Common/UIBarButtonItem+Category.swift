//
//  UIBarButtonItem+Category.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 9/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem{

    
    //
    class func createBarItemButton(imageName:String,target:AnyObject?,action: Selector)->UIBarButtonItem{
        let button = UIButton()
        button.setImage(UIImage(named: imageName), forState:UIControlState.Normal)
        button.setImage(UIImage(named: imageName+"_highlighted"), forState:UIControlState.Highlighted)
        button.sizeToFit()

        button.addTarget(target, action: action,forControlEvents: UIControlEvents.TouchUpInside)
        return UIBarButtonItem(customView: button)

    }


}
