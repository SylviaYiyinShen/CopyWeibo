//
//  BaseTableViewController.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 8/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, VisitorViewDelegate{

    
    var userLogin = false
    var visitorView:VisitorView?
        
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
    override func loadView() {
        userLogin ? super.loadView() : setupVisitorView()
        
       
    }

    private func setupVisitorView(){
        
        let customView =  VisitorView()
        //customView.backgroundColor = UIColor.redColor()
        customView.delegate = self
        
        view = customView
        visitorView = customView
        
        //set navigation button for unlogined user
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(BaseTableViewController.registerBtnDidClick) )
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(BaseTableViewController.loginBtnDidClick) )
        
        //set color of the text on navigation buttons, //change to setting color of the global appearance in AppDelegate
        //navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        
        
    }
    
    
    // MARK: - VisitorViewDelegte functions
    func loginBtnDidClick() {
        print(#function)
        //show login page
        let oAuVC =  OAuthViewController()
        let navigation = UINavigationController(rootViewController: oAuVC)
        presentViewController(navigation, animated:true, completion: nil)
        
    }
    
    func registerBtnDidClick() {
        print(#function)
    }
}
