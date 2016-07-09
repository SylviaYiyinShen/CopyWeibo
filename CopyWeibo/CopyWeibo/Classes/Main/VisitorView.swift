//
//  VisitorView.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 8/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit
protocol VisitorViewDelegate : NSObjectProtocol{
    //login callback
    func loginBtnDidClick()
    //register callback
    func registerBtnDidClick()

}

class VisitorView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    //must be weak to avoid circle reference
    weak var delegate : VisitorViewDelegate?
    

    // set different content of the child table view controller
    func setupVisitorInfo(isHome:Bool,imageName:String,message:String){
        
        iconView.hidden = !isHome
        homeView.image = UIImage(named: imageName)
        messageLabel.text=message
        
        if isHome{
            startAnimation()
        
        }
    
    }

    override init(frame: CGRect) {
        super.init(frame:frame)
        
        addSubview(iconView)
        addSubview(maskingView)
        addSubview(homeView)
        addSubview(messageLabel)
        addSubview(loginBtn)
        addSubview(registerBtn)
        
        iconView.xmg_AlignInner(type: XMG_AlignType.Center, referView:self, size:nil)
        maskingView.xmg_Fill(self)
        homeView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size:nil)
        messageLabel.xmg_AlignVertical(type: XMG_AlignType.BottomCenter,referView: iconView, size: nil)
        let widthConstraint = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224)
        addConstraint(widthConstraint)
        
        registerBtn.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: messageLabel, size: CGSize(width:100,height: 30),offset: CGPoint(x:0,y:20))
        
        loginBtn.xmg_AlignVertical(type: XMG_AlignType.BottomRight, referView: messageLabel, size: CGSize(width:100,height: 30),offset: CGPoint(x:0,y:20))    }
    
    //swift suggests create custom view via code or xib/storyboard
    required init?(coder aDecoder: NSCoder) {
        
        //using xib/storyboard create instance will result in crash
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lazy components
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named:"visitordiscover_feed_image_smallicon"))
        return iv
    
    }()
    
    
    
    private lazy var homeView: UIImageView = {
        let hv = UIImageView(image: UIImage(named:"visitordiscover_feed_image_house"))
        return hv
        
    }()
    
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "this is the content of the label"
        label.numberOfLines = 0
        label.textColor=UIColor.darkGrayColor()
        return label
    }()
    
    private lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setTitle("Login", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState.Normal)
        
        btn.addTarget(self, action: #selector(VisitorView.loginBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    
    }()
    
    func loginBtnClick(){
        print(#function)
        delegate?.loginBtnDidClick()
    
    }
    
    private lazy var registerBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setTitle("Register", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState.Normal)
        
        btn.addTarget(self, action: #selector(VisitorView.registerBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
        
    }()
    
    func registerBtnClick(){
        print(#function)
        delegate?.registerBtnDidClick()
    
    }
    
    private lazy var maskingView: UIImageView = {
    
        let iv = UIImageView(image:UIImage(named:"visitordiscover_feed_mask_smallicon"))
        return iv
    }()
    
    // MARK: - rotate animation of the icon view
    private func startAnimation(){
        
        print("rotate func")
        //1. create animation
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        //2. setup animation
        animation.toValue = 2*M_PI
        animation.duration = 20
        animation.repeatCount = MAXFLOAT
        animation.removedOnCompletion = false
        print(animation)
        //3. add animation to the image
        iconView.layer.addAnimation(animation, forKey: nil)
        
    }

}
