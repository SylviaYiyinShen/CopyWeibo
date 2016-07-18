//
//  StatusTableHeaderView.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 18/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

class StatusTableHeaderView: UIView {
    
    var status: Status?
        {
        didSet{
            

            //            textLabel?.text = status?.text
            nameLabel.text = status?.user?.name
            
            timeLabel.text = "right now"
            sourceLabel.text = "from: Sylvia Institution"
            
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

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI(){
        
        
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
    
        //layout
        iconView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: self, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        
        verifiedView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x:5, y:5))
        nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
    }
    
    
    
    
    // MARK: -- lazy components

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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
