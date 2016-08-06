//
//  UIImage+Category.swift
//  01-图片选择器
//
//  Created by xiaomage on 15/9/18.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit


extension UIImage
{
    /**
    generate image by the given width
    */
    func imageWithScale(width: CGFloat) -> UIImage
    {
        // 1. calculate height  according to the original x/y scale
        let height = width *  size.height / size.width
        
        // 2.按照宽高比绘制一张新的图片
        let currentSize = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContext(currentSize)
        drawInRect(CGRect(origin: CGPointZero, size: currentSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}