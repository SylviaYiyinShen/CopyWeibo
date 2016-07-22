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

enum StatusTableViewCellIdentifier : String{
    
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
    
    static func cellID(status:Status)->String{
    
        return status.retweeted_status != nil ? ForwardCell.rawValue : NormalCell.rawValue
    }

}

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
        //register notification for picture view
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showPictureBrowser), name: PictureSelectedNotice, object: nil)
        
        
        
        
        
        //register two cellc for the table view
        
        //tableView.registerClass(StatusTableViewCell.self, forCellReuseIdentifier: HOME_CELL_ID)
        tableView.registerClass(StatusNormalTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.NormalCell.rawValue)
        tableView.registerClass(StatusForwardTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.ForwardCell.rawValue)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        //refresh to load more status
//        refreshControl = UIRefreshControl()
//        let refreshChildView = UIView()
//        refreshChildView.backgroundColor = UIColor.redColor()
//        refreshChildView.frame = CGRect(x: 0, y: 0, width: 375, height: 60)
//        refreshControl?.addSubview(refreshChildView)
        
        
        refreshControl = HomeRefreshControl()
        refreshControl?.addTarget(self, action: #selector(HomeTableViewController.loadData), forControlEvents: UIControlEvents.ValueChanged)
        
//        newStatusLabel.hidden = false
        
        //load data for weibo posts
        loadData()
        
        
    }
   
    
    var pullUpFlag = false
    //must not be private, could be @objc
   @objc private func loadData(){
    
    /*retrun the latest 20 status by default
        since_id: return status bigger than since_id
        max_id:   smaller than max_idd
     
     
     */
    
        //pull down by default
        var since_id = statuses?.first?.id ?? 0
        var max_id = 0
        if pullUpFlag{
            since_id = 0
            max_id = statuses?.last?.id ?? 0
            
        }
    
    Status.loadStatuses(since_id,max_id:max_id){ (models, error) in
            
            if error != nil{
                return
            
            }
            self.refreshControl?.endRefreshing()
            
            //loading more latest statuses
            if since_id>0{
                self.statuses = models! + self.statuses!
                
                self.showNewStatusCount(models?.count ?? 0)
            }else if max_id>0{
                //loading more old statuses
                self.statuses = self.statuses! + models!
                
            }else{
            
                self.statuses =  models
                
            }
            
        }
    
    
    }
    
    
    deinit{
    
        NSNotificationCenter.defaultCenter().removeObserver(self)
    
    }
    
    
    
    private func showNewStatusCount(count:Int){
        newStatusLabel.hidden = false
        newStatusLabel.text = (count == 0) ? "No new status" : "\(count) new statuses"
        
       
        
         //set animation
        
        /*  has tiny bugs
        let rect = newStatusLabel.frame
        UIView.animateWithDuration(2, animations: {
            UIView.setAnimationRepeatAutoreverses(true)
            self.newStatusLabel.frame = CGRectOffset(rect, 0, 3*rect.height)
            
            }) { (_) in
            self.newStatusLabel.frame = rect
        }
         */
        
        
        UIView.animateWithDuration(2, animations: { 
            
            self.newStatusLabel.transform = CGAffineTransformMakeTranslation(0, self.newStatusLabel.frame.height)
            }) { (_) in
                
            UIView.animateWithDuration(2, animations: { 
                self.newStatusLabel.transform = CGAffineTransformIdentity
                
                }, completion: { (_) in
                    
                    self.newStatusLabel.hidden = true
            })
        }
        
    }
    
    //when notified
    func updateTitleBtn(){
        
        let titleBtn = navigationItem.titleView as! TitleButton
        titleBtn.selected = !titleBtn.selected
        
    
    
    }
    
    func showPictureBrowser(notify:NSNotification){
        print(notify.userInfo)
     
        guard notify.userInfo![PictureSelectedIndexKey] != nil else{
            print("No indexpath value")
            return
        }
        
        guard notify.userInfo![PictureSelectedURLKey] != nil else{
            print("No picture urls value")
            return
        }
        
        //create picture browser
        let index = (notify.userInfo![PictureSelectedIndexKey] as! NSIndexPath).item
        let urls = notify.userInfo![PictureSelectedURLKey] as! [NSURL]
        let vc = PictureBrowserController(currentIndex:index,pictureURLs:urls)
        presentViewController(vc, animated: true, completion: nil)
        
    
    
    }
    
    private func setupNavigation(){
    
        //1. create navigationBarItem button
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarItemButton("navigationbar_friendattention",target: self,action: #selector(HomeTableViewController.leftItemClick))
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem.createBarItemButton("navigationbar_pop",target: self,action: #selector(HomeTableViewController.rightItemClick))
       
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
    
    
    private lazy var newStatusLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.orangeColor()
        label.textAlignment =  NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.whiteColor()
        let height:CGFloat = 44
        
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: height)
        //self.tableView.addSubview(label)
        
        self.navigationController?.navigationBar.insertSubview(label,atIndex:0)
        return label
    
    }()
}

extension HomeTableViewController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return statuses?.count ?? 0
    }


    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let status = statuses![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status), forIndexPath: indexPath) as! StatusTableViewCell

        cell.status = status
        
        
        // check if reached the last status
        let count = statuses?.count ?? 0
        if indexPath.row == (count-1){
            pullUpFlag = true
            loadData()
        }
        
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status)) as! StatusTableViewCell
        //get the hight 
        let rowHeight = cell.rowHeight(status)
        //store in cache
        rowHeightCache[status.id]=rowHeight
        
        return rowHeight
    }


}

