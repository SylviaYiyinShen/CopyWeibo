//
//  MainViewController.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 6/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        tabBar.tintColor = UIColor.orangeColor()
        
        //1. create the main page
        //let home = HomeTableViewController()
        addChildViewController(HomeTableViewController(),title:"Home",imageName:"tabbar_home")
        addChildViewController(DiscoverTableViewController(),title:"Discover",imageName:"tabbar_message_center")
        addChildViewController(MessageTableViewController(),title:"Message",imageName:"tabbar_discover")
        addChildViewController(ProfileTableViewController(),title:"Profile",imageName:"tabbar_profile")
        
        
       
    }
    

   
    
    //initialize child view controller
    private func addChildViewController(childController: UIViewController, title:String, imageName:String){
    
    
        //1.1 create tabbar items
        
        childController.tabBarItem.image = UIImage(named:imageName)
        childController.tabBarItem.selectedImage = UIImage(named:imageName+"_highlighted")
        
        
        //1.2 navigation title
        
        childController.title = title
        //will do the following two things at the same tile
        //home.tabBarItem.title = "Home"
        //home.navigationItem.title = "Home"
        
        //2.create the navigation bar
        
        let navigationBar = UINavigationController()
        navigationBar.addChildViewController(childController)
        
        //3.add navigation bar to the current vewi UITabBarController
        addChildViewController(navigationBar)
    
    }
   
}
