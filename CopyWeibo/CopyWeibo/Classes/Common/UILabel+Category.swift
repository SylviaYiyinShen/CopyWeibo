//
//  UILabel+Category.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 15/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//
import UIKit


extension UILabel{

    class func createLabel(color:UIColor, fontSize:CGFloat)->UILabel{
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFontOfSize(fontSize)
        return label
    
    }


}