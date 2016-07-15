//
//  StatusTableViewCell.swift
//  DSWeibo
//
//  Created by xiaomage on 15/9/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit
import SDWebImage

class StatusTableViewCell: UITableViewCell {

    var status: Status?
        {
        didSet{
//            textLabel?.text = status?.text
            nameLabel.text = status?.user?.name
            
            timeLabel.text = "right now"
            sourceLabel.text = "from: Sylvia Institution"
            contentLabel.text = status?.text
            
            //set image of user
            if let icon_url = status?.user?.image_url {
            
                 iconView.sd_setImageWithURL(icon_url)
            
            }
            
            //set verified icon
            verifiedView.image = status?.user?.verifiedImage
            //set member level icon
            vipView.image = status?.user?.memberRankImage
            
            //set source
            sourceLabel.text = status?.source
            
            //set time
            timeLabel.text = status?.created_at
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI()
    {
        // 1.add components
        contentView.addSubview(iconView)
        contentView.addSubview(verifiedView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(vipView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(footerView)
        footerView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
        // 2.set layout of child components
        iconView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        
        verifiedView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x:5, y:5))
        nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 10))
        
        // constraint of footer view
//        contentLabel.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
        
        let width = UIScreen.mainScreen().bounds.width
        footerView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
        
        footerView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
    }

    
    // MARK: - lazy components
    
    private lazy var iconView: UIImageView =
    {
       let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        return iv
    }()
    
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    
    
    private lazy var nameLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    

    private lazy var timeLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    
    private lazy var sourceLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)

    private lazy var contentLabel: UILabel =
    {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
        }()
    
    /// footer view
    private lazy var footerView: StatusFooterView = StatusFooterView()

}

class StatusFooterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    
    
    private func setupUI()
    {
        // 1.add child components
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commonBtn)
    
        // 2.set layout of child components
        xmg_HorizontalTile([retweetBtn, unlikeBtn, commonBtn], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    // MARK: - lazy components
    // forward
    private lazy var retweetBtn: UIButton = UIButton.createButton( "timeline_icon_retweet", title: "Retweet")
    // Like
    private lazy var unlikeBtn: UIButton = UIButton.createButton( "timeline_icon_unlike", title: "Like")
    // Commment
    private lazy var commonBtn: UIButton = UIButton.createButton( "timeline_icon_comment", title: "Comment")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
