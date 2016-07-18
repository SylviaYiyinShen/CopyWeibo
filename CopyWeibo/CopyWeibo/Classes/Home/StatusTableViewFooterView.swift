//
//  StatusTableViewFooterView.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 18/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

class StatusTableViewFooterView: UIView {

        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setupUI()
        }
        
        
        
        private func setupUI()
        {
            
            backgroundColor = UIColor(white: 0.2, alpha: 0.5)
            
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
