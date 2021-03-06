//
//  StatusTableViewCell.swift
//  DSWeibo
//
//  Created by xiaomage on 15/9/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit
import SDWebImage
import KILabel

let PICTURE_CELL_ID = "PICTURE_CELL_ID"
class StatusTableViewCell: UITableViewCell {

    
    var pictureWidthCons: NSLayoutConstraint?
    var pictureHeightCons: NSLayoutConstraint?
    var pictureTopCons: NSLayoutConstraint?
    
    var status: Status?
        {
        didSet{
            
            headerView.status = status
  
            contentLabel.text = status?.text
            
            pictureView.status = status?.retweeted_status != nil ? status?.retweeted_status :status
            
            
            //set layout constraint of pictureview
            //1.1 calculate size(requires status model)
            let size = pictureView.calculateImageSize()
            //1.2 set size of picture view
            pictureWidthCons?.constant = size.width
            pictureHeightCons?.constant = size.height
            pictureTopCons?.constant = size.height == 0 ? 0 : 10

        }
    }
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        setupUI()

    }

    
    //not private -> for overriding in forward cell view
    func setupUI()
    {
        // 1.add components
        contentView.addSubview(headerView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(footerView)


        let width = UIScreen.mainScreen().bounds.width
        
        // 2.set layout of child components
        headerView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSize(width: width,height: 60))

        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView:headerView, size: nil, offset: CGPoint(x: 10, y: 10))
        
//        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero,offset: CGPoint(x: 0, y: 10))
//        
//        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
//        pictureHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
//        
        
        
        footerView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
        
    }
    
    //get the height of row
    func rowHeight(status:Status)->CGFloat{
        
        //to invoke didSet,calculate the height
        self.status = status
        // force to update view
        self.layoutIfNeeded()
        
        //get the maximum-Y of the footview
        
        return CGRectGetMaxY(footerView.frame)
        
        
        
    }
    
    // MARK: - lazy components
    
    private lazy var headerView: StatusTableHeaderView = StatusTableHeaderView()
    lazy var contentLabel: KILabel =
    {
        //let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
        
        let label = KILabel()
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(14)
        
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        
        
        //set click listener on url
        label.urlLinkTapHandler = {
        
            (label,string,range) in
            print(string)
        
        }
        
        
        return label
        }()
    
    
 
    lazy var pictureView: StatusTableViewPictureView = StatusTableViewPictureView()
    /// footer view
    lazy var footerView: StatusTableViewFooterView = StatusTableViewFooterView()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





