//
//  PopupMenuPresentationController.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 9/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class PopupMenuPresentationController: UIPresentationController {
    
    
    
    var presentFrame = CGRectZero
    
    
    
    //presentedViewController: UIViewController, -> popup menu
    //presentingViewController: UIViewController -> home view controller
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        
        
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        
        //print(presentedViewController)
        //print(presentingViewController)
        
        
    }
    
    
    //change size.. of the popup menu
    override func containerViewWillLayoutSubviews(){
        //containerView -> contains the menu and lays above other elements
        //presentedView -> the presented popup menu
        
        
        if presentFrame ==  CGRectZero {
            
            presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)

        
        }else{
            presentedView()?.frame = presentFrame
        
        
        }
        
        
        
        
        
        //for better user interaction, insert a grey layer on the containerView
        
        containerView?.insertSubview(coverView, atIndex: 0)
        
    
    
    }
    
    // MARK: cover
    private lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor(white:0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PopupMenuPresentationController.closeMenu))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    func closeMenu(){
        //close the popup menu
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    
    }

}
