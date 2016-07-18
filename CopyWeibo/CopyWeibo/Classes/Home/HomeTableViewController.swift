//
//  HomeTableViewController.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 6/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit
import AFNetworking

let HOME_CELL_ID = "HOME_CELL_ID"

class HomeTableViewController: BaseTableViewController{
    
    //key:status id, value: height of row
    var rowHeightCache: [Int:CGFloat] = [Int:CGFloat]()
    override func didReceiveMemoryWarning() {
        rowHeightCache.removeAll()
    }
    
    var statuses :[Status]?{
    
        didSet{
        
            //update the table list after get the statuses
            tableView.reloadData()
        
        }
    
    }
    
    

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
        
        
        
        //register cell for the table view
        
        //tableView.registerClass(StatusTableViewCell.self, forCellReuseIdentifier: HOME_CELL_ID)
        tableView.registerClass(StatusNormalTableViewCell.self, forCellReuseIdentifier: HOME_CELL_ID)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        //load data for weibo posts
        loadData()
        
        
    }
    
    private func loadData(){
        Status.loadStatuses { (models, error) in
            
            if error != nil{
                return
            
            }
            self.statuses =  models
        }
    
    
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
        
        let storyboard =  UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        presentViewController(viewController!, animated: true, completion: nil)
    
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

extension HomeTableViewController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return statuses?.count ?? 0
    }


    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(HOME_CELL_ID, forIndexPath: indexPath) as! StatusTableViewCell
        let status = statuses![indexPath.row]
//        cell.textLabel?.text =  status.text
        //cell.textLabel?.text =  status.user?.name
        cell.status = status
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //get row
        let status = statuses![indexPath.row]
        
        //check the row if exists in cache
        if let rowHeight = rowHeightCache[status.id] {
        
            return rowHeight
        }
        
        //get the cell
        let cell = tableView.dequeueReusableCellWithIdentifier(HOME_CELL_ID) as! StatusTableViewCell
        //get the hight 
        let rowHeight = cell.rowHeight(status)
        //store in cache
        rowHeightCache[status.id]=rowHeight
        
        return rowHeight
    }


}

