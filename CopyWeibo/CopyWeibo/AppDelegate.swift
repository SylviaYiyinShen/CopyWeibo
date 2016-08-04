//
//  AppDelegate.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 18/06/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

//for notification
let SwitchRootViewControllerKey = "SwitchRootViewControllerKey"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func switchRootViewController(notice:NSNotification){
        
        if notice.object as! Bool{
            window?.rootViewController = MainViewController()
        
        
        }else{
            window?.rootViewController = WelcomeViewController()
        }
       
    
    
    }
    
    deinit{
    
    
        NSNotificationCenter.defaultCenter().removeObserver(self)
    
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //local database
        SQLiteManager.shareManager().openDB("weibo.sqlite")
        
        
        
        //register notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.switchRootViewController(_:)), name: SwitchRootViewControllerKey, object: nil)
        
        
        //testing only
        //print(UserAccount.loadAccount())
        
        //1.create the window
        window=UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        
        //2.create the root view controller
//        window?.rootViewController = MainViewController()
        //window?.rootViewController = OAuthViewController()
//        window?.rootViewController = NewFeaturesCollectionViewController()
//        window?.rootViewController = WelcomeViewController()
        window?.rootViewController = defaultRootController()
        window?.makeKeyAndVisible()
        
        //3. set global color
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor =  UIColor.orangeColor()
        
        
        
        checkUpdate()
        return true
    }

    private func defaultRootController()->UIViewController{
        
        //login-> check new version
        if UserAccount.isLogin(){
            
            return checkUpdate() ?  NewFeaturesCollectionViewController() :WelcomeViewController()
        
        
        }
    
        
        return MainViewController()
    }
    
    private func checkUpdate()->Bool{
    
        //1. get the current version -> info.plist                  CFBundleShortVersionString
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        //2. get the previous version -> read from local file
        let sandboxVersion = NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""// ?? ""  : if value== nil, set to ""
        
        
        
        
        //3. compare current version with precious version
        
        print("current:\(currentVersion)  sandbox:\(sandboxVersion)")
        //3.1 current>precious
//        3.1.1 save current version
        if currentVersion.compare(sandboxVersion)==NSComparisonResult.OrderedDescending{
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        

        //3.2 current <= precious
        
        return false
    
    }
    
    /*
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    */


}

