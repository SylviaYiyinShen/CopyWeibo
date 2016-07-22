//
//  HomeRefreshControl.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 20/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

class HomeRefreshControl: UIRefreshControl {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init() {
        super.init()
        
        setupUI()
    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        setupUI()
//    }
    
    private func setupUI(){
        
        addSubview(refreshView)
        refreshView.xmg_AlignInner(type: XMG_AlignType.Center, referView:self, size: CGSize(width: 160, height: 60))
        
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
        
        
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopLoadingViewAnim()
        loadingFlag = false
    }
    
    // MARK: -- lazy components
    private lazy var refreshView: HomeRefreshView = HomeRefreshView.refreshView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
    
        removeObserver(self, forKeyPath: "self")
    
    
    }
    
    private var loadingFlag = false
    private var rotateFlag = false
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        print(frame.origin.y)// up: value increase  down: value decrease
        
        //filter the initial value
        if frame.origin.y >= 0{
            return
        }
        
        //check if refreshing triggered
        
        if refreshing && !loadingFlag{
            //show the loading icon
            refreshView.startLoadingViewAnim()
            loadingFlag = true
        
        }
        
        if frame.origin.y >= -50 && rotateFlag{
            rotateFlag = false
            refreshView.rotateArrowIcon(rotateFlag)
        
        }else if frame.origin.y < -50 && !rotateFlag{
            rotateFlag = true
            refreshView.rotateArrowIcon(rotateFlag)
        }
        
    }

    

}


class HomeRefreshView: UIView{

    @IBOutlet weak var arrowIcon: UIImageView!
    
    @IBOutlet weak var tipView: UIView!
    
    
    @IBOutlet weak var loadingIcon: UIImageView!
    
    
    
    func rotateArrowIcon(rotateFlag:Bool){
        
        var angle = M_PI
        angle += rotateFlag ? -0.01 : 0.01
        UIView.animateWithDuration(0.2) { 
            self.arrowIcon.transform = CGAffineTransformRotate(self.arrowIcon.transform, CGFloat(angle))
        }
    
        
    }
    func startLoadingViewAnim(){
        
        tipView.hidden = true
        
        //1. create animation
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        //2. setup animation
        animation.toValue = 2*M_PI
        animation.duration = 1
        animation.repeatCount = MAXFLOAT
        animation.removedOnCompletion = false
        print(animation)
        //3. add animation to the image
        loadingIcon.layer.addAnimation(animation, forKey: nil)
    
    }
    
    func stopLoadingViewAnim(){
    
        loadingIcon.layer.removeAllAnimations()
        tipView.hidden = false
    }

    
    class func refreshView() -> HomeRefreshView{
    
        return NSBundle.mainBundle().loadNibNamed("HomeRefreshView", owner: nil, options: nil).last as! HomeRefreshView
    }

}
