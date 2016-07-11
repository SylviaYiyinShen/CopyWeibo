//
//  PopupMenuAnimator.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 11/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

//name of notifications
let PopupWillPresent = "PopupWillPresent"
let PopupWillDismiss = "PopupWillDismiss"

class PopupMenuAnimator: NSObject, UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning{
    
    // if the popupmenu is presented
    var isPresent: Bool = false
    // size of the popupmenu
    var presentFrame = CGRectZero
    
    @available(iOS 8.0, *)
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        
        let presentationController = PopupMenuPresentationController(presentedViewController: presented,presentingViewController: presenting)
        
        presentationController.presentFrame = presentFrame
        return presentationController
        
    }
    
    
    // change the animation when popup, the default animation will not work
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = true
        
        //tell homeViewController
        NSNotificationCenter.defaultCenter().postNotificationName(PopupWillPresent, object: self)
        
        
        return self
    }
    
    
    //change the animation when disappear, the default animation will not work
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = false
        
        //tell homeViewController
        NSNotificationCenter.defaultCenter().postNotificationName(PopupWillDismiss, object: self)
        
        return self
        
    }
    
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    //animation duration
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        
        return 0.5
    }
    
    // popup/dispaear animation
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        
        //modify the transform
        
        if isPresent{//show the menu
            
            
            
            //1. get the presented view
            //1.1 get menu view
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            
            
            //let fromViewController = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            //print to test:  toVC->popupmenuview, fromVC: mainviewcontroller
            
            //1.2 add menu view to container view
            transitionContext.containerView()?.addSubview(toView)
            //1.3 set anchor point
            toView.layer.anchorPoint =  CGPoint(x: 0.5, y: 0)
            
            
            //2. set animation
            toView.transform = CGAffineTransformMakeScale(1.0,0.0)
            
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                // 2.1 cancel transform
                toView.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                // 2.2 must notify the system after completion of animation
                transitionContext.completeTransition(true)
            }
            
        }else{//clost the menu
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                
                //CGFloat is not accurate, 0.0(no animation)->0,0000001
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.000001)
                }, completion: { (_) -> Void in
                    transitionContext.completeTransition(true)
            })
            
        }
        //check recording 15:00
        
    }
    
}
