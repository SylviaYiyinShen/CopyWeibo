//
//  StatusTableViewCell.swift
//  DSWeibo
//
//  Created by xiaomage on 15/9/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit
import SDWebImage

let PICTURE_CELL_ID = "PICTURE_CELL_ID"
class StatusTableViewCell: UITableViewCell {

    
    var pictureWidthCons: NSLayoutConstraint?
    var pictureHeightCons: NSLayoutConstraint?
    
    var status: Status?
        {
        didSet{
            
            headerView.status = status
            pictureView.status = status
            contentLabel.text = status?.text
            

            
            //set layout constraint of pictureview
            //1.1 calculate size(requires status model)
            let size = pictureView.calculateImageSize()
            //1.2 set size of picture view
            pictureWidthCons?.constant = size.width
            pictureHeightCons?.constant = size.height

        }
    }
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        setupUI()

    }

    private func setupUI()
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
        
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero,offset: CGPoint(x: 0, y: 10))
        
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
        
        
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
    private lazy var contentLabel: UILabel =
    {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
        }()
    
    
 
    private lazy var pictureView: StatusTableViewPictureView = StatusTableViewPictureView()
    /// footer view
    private lazy var footerView: StatusTableViewFooterView = StatusTableViewFooterView()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





