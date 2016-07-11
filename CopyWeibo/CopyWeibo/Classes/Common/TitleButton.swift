//
//  TitleButton.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 9/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(UIImage(named:"navigationbar_arrow_down"), forState: UIControlState.Normal)
        setImage(UIImage(named:"navigationbar_arrow_up"), forState: UIControlState.Selected)
        setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        sizeToFit()
        
    }
    
    //not allowed storyboard to be used
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        //change the left right position of the title and the button
        
        //but this block will be invoke twice -> multiple by 0.5
//        titleLabel?.frame.offsetInPlace(dx: -(imageView?.bounds.width)!*0.5, dy: 0)
//        imageView?.frame.offsetInPlace(dx: (titleLabel?.bounds.width)!*0.5, dy: 0)
        
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.size.width
        
        
    }
    
}
