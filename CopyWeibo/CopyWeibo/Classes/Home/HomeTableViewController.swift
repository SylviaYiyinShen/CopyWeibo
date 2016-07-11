//
//  HomeTableViewController.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 6/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        if !userLogin
        {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "This is the home page")
        
            return
        
        }
        
        //setup navigation after login
        setupNavigation()
        
        //register notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.updateTitleBtn), name: PopupWillPresent, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.updateTitleBtn), name: PopupWillDismiss, object: nil)
    }
    
    
    deinit{
    
        NSNotificationCenter.defaultCenter().removeObserver(self)
    
    }
    
    
    //when notified
    func updateTitleBtn(){
        
        let titleBtn = navigationItem.titleView as! TitleButton
        titleBtn.selected = !titleBtn.selected
        
    
    
    }
    private func setupNavigation(){
    
        //1. create navigationBarItem button
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarItemButton("navigationbar_friendattention",target: self,action: #selector(HomeTableViewController.leftItemClick))
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem.createBarItemButton("navigationbar_pop",target: self,action: #selector(HomeTableViewController.rightItemClick))
        
        //navigationItem.leftBarButtonItem = createBarItemButton("navigationbar_friendattention",target: self,action: #selector(HomeTableViewController.leftItemClick))
        //navigationItem.rightBarButtonItem = createBarItemButton("navigationbar_pop",target: self,action: #selector(HomeTableViewController.rightItemClick))
       
        //2. initialize navigation title button
        let titleBtn =  TitleButton()
        titleBtn.setTitle("My Name ", forState: UIControlState.Normal)
        titleBtn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
        
    }
    
    
    func titleBtnClick(btn:TitleButton){
        
        //1. change the button icon
        //btn.selected = !btn.selected
        
        //2. show the popup menu
        let storyboard = UIStoryboard(name: "PopupMenuViewController", bundle: nil)
        let menuViewController = storyboard.instantiateInitialViewController()
        
        //2.1 transition delegate
        //menuViewController?.transitioningDelegate = self
        //must maintain a reference to the animator, PopupMenuAnimator() will cause error
        menuViewController?.transitioningDelegate = popupMenuAnimator
        
        
        //2.2 transition animation
        menuViewController?.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(menuViewController!, animated: true, completion: nil)
        
    
    }
    
    func rightItemClick(){
        print(#function)
    
    }
    
    func leftItemClick(){
        print(#function)
        
    }
    
    
   // MARK: --Animator
    
    
    //HomeTableViewController -> PopupMenuAnimator -> PopupMenuPresentationController
    private lazy var popupMenuAnimator :PopupMenuAnimator = {
    
        let animator = PopupMenuAnimator()
        animator.presentFrame =  CGRect(x: 100, y: 56, width: 200, height: 350)
        return animator
    }()
}

