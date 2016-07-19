//
//  StatusForwardTableViewCell.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 19/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

class StatusForwardTableViewCell: StatusTableViewCell {
    
    //will not overwrite super
    override var status: Status?{
        didSet{
            
                let name = status?.retweeted_status?.user?.name ?? ""
                let text = status?.retweeted_status?.text ?? ""
                forwardlabel.text = name + ": " + text
        
        }

    }
    
    override func setupUI(){
        super.setupUI()
        
        //contentView.addSubview(forwardBackgound)
        contentView.insertSubview(forwardBackgound, belowSubview: pictureView)
        contentView.insertSubview(forwardlabel, aboveSubview: forwardBackgound)
        
        forwardBackgound.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView:contentLabel, size: nil
            , offset: CGPoint(x: -10, y: 10))
        forwardBackgound.xmg_AlignVertical(type: XMG_AlignType.TopRight, referView: footerView, size: nil)
        

        forwardlabel.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: forwardBackgound, size: nil,offset: CGPoint(x: 10, y: 10))
        
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: forwardlabel, size: CGSizeZero,offset: CGPoint(x: 0, y: 10))
        
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureTopCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Top)
        
    }
    
    
    // MARK: new lazy components
    private lazy var forwardlabel:UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
    }()
    
    private lazy var forwardBackgound:UIButton = {
        let btn = UIButton()
        
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        
        return btn
        
    }()
    


}
