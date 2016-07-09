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
        
        //change to setting color of the global appearance in AppDelegate
        //tabBar.tintColor = UIColor.orangeColor()
        
        

        addChildViewControllers()
        
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupComposeBtn()
    }
    
    private func setupComposeBtn(){
        tabBar.addSubview(composeBtn)
        let width=UIScreen.mainScreen().bounds.size.width/CGFloat((viewControllers?.count)!)
        let rect=CGRect(x:0,y:0,width:width,height: 44)
        composeBtn.frame=CGRectOffset(rect, 2*width,0)
    
    }
    

   
    private func addChildViewControllers(){
        //create view controllers from the JSON file
        let path=NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType:nil)
        if let jsonPath=path{
            let jsonData=NSData(contentsOfFile: jsonPath)
            
            do{
                let dictionaryArray = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
                //print(dictionaryArray)
                //travase the dictionary to create view controller
                for vcDictionary in dictionaryArray as! [[String:String]]{
                    addChildViewController(vcDictionary["vcName"]!, title: vcDictionary["title"]!, imageName: vcDictionary["imageName"]!)
                    
                }
                
                
                
            }catch{
                print(error)
                //      addChildViewController("HomeTableViewController",title:"Home",imageName:"tabbar_home")
                //        addChildViewController(HomeTableViewController(),title:"Home",imageName:"tabbar_home")
                //        addChildViewController(DiscoverTableViewController(),title:"Discover",imageName:"tabbar_message_center")
                //        addChildViewController(MessageTableViewController(),title:"Message",imageName:"tabbar_discover")
                //        addChildViewController(ProfileTableViewController(),title:"Profile",imageName:"tabbar_profile")
                
                //
                
            }
            
        }

    
    }
    //initialize child view controller
//    private func addChildViewController(childController: UIViewController, title:String, imageName:String){
    private func addChildViewController(childControllerName: String, title:String, imageName:String){

        
        
        //1. get name space to create instance
        let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        let childClass:AnyClass?=NSClassFromString(nameSpace+"."+childControllerName)
        childClass?.initialize()
        
        let vcClass=childClass as! UIViewController.Type
        let vcInstance=vcClass.init()
        
         //2. create tabbar items
        vcInstance.tabBarItem.image = UIImage(named:imageName)
        vcInstance.tabBarItem.selectedImage = UIImage(named:imageName+"_highlighted")
        vcInstance.title = title
        
        //3. create navigation bar
        let navigationBar = UINavigationController()
        navigationBar.addChildViewController(vcInstance)
        
        //4.add navigation bar to the current vewi UITabBarController
        addChildViewController(navigationBar)
        
        //1.1 create tabbar items
        
//        childController.tabBarItem.image = UIImage(named:imageName)
//        childController.tabBarItem.selectedImage = UIImage(named:imageName+"_highlighted")

        //1.2 navigation title
        
        //childController.title = title
        //will do the following two things at the same tile
        //home.tabBarItem.title = "Home"
        //home.navigationItem.title = "Home"
        
        //2.create the navigation bar
        
        //let navigationBar = UINavigationController()
        //navigationBar.addChildViewController(childController)
        
        //3.add navigation bar to the current vewi UITabBarController
        //addChildViewController(navigationBar)
    
    }
    
    
    
    // MARK: composebutton click event control
    //should not be private
    func composeBtnClick(){
    
    
    }
    // MARK: -Lazy loading for the add button
    private lazy var composeBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"),forState:UIControlState.Normal)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"),forState:UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"),forState:UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"),forState:UIControlState.Highlighted)
        
        btn.addTarget(self, action: "composeBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
   
}
