//
//  AppDelegate.swift
//  PhotoPicker
//
//  Created by Yiyin Shen on 4/08/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = PhotoPickerViewController()
        window?.makeKeyAndVisible()
        

        return true
    }

}

