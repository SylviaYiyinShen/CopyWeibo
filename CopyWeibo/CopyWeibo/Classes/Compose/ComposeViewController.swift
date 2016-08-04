//
//  ComposeViewController.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 22/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {

    var tabBarBottomCons:NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //register for keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.keyboardChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        setupNavigation()
        setupInputView()
        
        

    }
    
    deinit{
    
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardChange(notify:NSNotification){
        
        // 1.get keyboard frame
        let value = notify.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rect = value.CGRectValue()
        
        // 2.update tabBarBottonCons
        // start : Y = 409 height = 258
        // end   : Y = 667 height = 258
        // 667 - 409 = 258
        // 667 - 667 = 0
        let height = UIScreen.mainScreen().bounds.height
        tabBarBottomCons?.constant = -(height - rect.origin.y)
        
        // 3.更新界面
        let duration = notify.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        
        /*
         工具条回弹是因为执行了两次动画, 而系统自带的键盘的动画节奏(曲线) 7
         7在apple API中并没有提供给我们, 但是我们可以使用
         7这种节奏有一个特点: 如果连续执行两次动画, 不管上一次有没有执行完毕, 都会立刻执行下一次
         也就是说上一次可能会被忽略
         
         如果将动画节奏设置为7, 那么动画的时长无论如何都会自动修改为0.5
         
         UIView动画的本质是核心动画, 所以可以给核心动画设置动画节奏
         */
        // 1.取出键盘的动画节奏
        let curve = notify.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
        UIView.animateWithDuration(duration.doubleValue) { () -> Void in
            // 2.设置动画节奏
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.integerValue)!)
            
            self.view.layoutIfNeeded()
        }
        
        let anim = toolBar.layer.animationForKey("position")
        print("duration = \(anim?.duration)")
    }
    
    private func setupBottomToolBar(){
        
        //add tool bar
        view.addSubview(toolBar)
        
        
        //add tool bar items

        var items = [UIBarButtonItem]()
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "selectPicture"],
                            
                            ["imageName": "compose_mentionbutton_background"],
                            
                            ["imageName": "compose_trendbutton_background"],
                            
                            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
                            
                            ["imageName": "compose_addbutton_background"]]
        for dict in itemSettings
        {
            
            let item = UIBarButtonItem(imageName: dict["imageName"]!, target: self, action: dict["action"])
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()//remove the spacing
        toolBar.items = items
        
        
        //set the position of toolBar
        
        let width = UIScreen.mainScreen().bounds.width
        let cons = toolBar.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize(width: width, height: 44))

        tabBarBottomCons = toolBar.xmg_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
    }
    
    func selectPicture(){
    
        
    }
    
    func inputEmoji(){
    
    
    }
    
    private func setupInputView(){
        
        view.addSubview(textView)
        
        textView.addSubview(placceHolder)
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        
        textView.xmg_Fill(view)
        placceHolder.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: textView, size: nil,offset: CGPoint(x: 5, y: 8))
        

        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupBottomToolBar()
        //show keyboard
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    
    // MARK: --lazy component
    private lazy var textView: UITextView = {
        let tv = UITextView()
         tv.delegate = self
        return tv
    }()
    
    private lazy var placceHolder: UILabel = {
        
        let placeHolder = UILabel()
        placeHolder.font = UIFont.systemFontOfSize(13)
        placeHolder.textColor = UIColor.darkGrayColor()
        placeHolder.text = "Share your ideas..."
        return placeHolder
    
    }()
    
    private lazy var toolBar = UIToolbar()
    
    private func setupNavigation(){
        // left right button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ComposeViewController.closeBtnClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ComposeViewController.postBtnClicked))
        navigationItem.rightBarButtonItem?.enabled = false
        
        
        
        // center view
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        
        let topLabel = UILabel()
        topLabel.text = "Post Status"
        topLabel.sizeToFit()
        topLabel.font = UIFont.systemFontOfSize(15)
        titleView.addSubview(topLabel)
        
        let bottomLabel = UILabel()
        bottomLabel.text = UserAccount.loadAccount()?.screen_name
        bottomLabel.sizeToFit()
        bottomLabel.font = UIFont.systemFontOfSize(13)
        bottomLabel.textColor = UIColor.darkGrayColor()
        titleView.addSubview(bottomLabel)
        
        
        topLabel.xmg_AlignInner(type: XMG_AlignType.TopCenter, referView: titleView, size: nil)
        bottomLabel.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: titleView, size: nil)
    
        navigationItem.titleView = titleView
    }
    
    
    func closeBtnClicked(){
    
        dismissViewControllerAnimated(true, completion: nil)
    }

    func postBtnClicked(){
        let path = "2/statuses/update.json"
        let params = ["access_token":UserAccount.loadAccount()?.access_token,
                      "status":textView.text]
        NetWorkTools.sharedInstance().POST(path, parameters: params, success: { (_, JSON) in
            //alert 
            SVProgressHUD.showSuccessWithStatus("Succeeded to post",maskType: SVProgressHUDMaskType.Black)
            //close page
            self.closeBtnClicked()
            
            }) { (_, error) in
                print(error)
                //alert
                SVProgressHUD.showErrorWithStatus("Failed to post",maskType: SVProgressHUDMaskType.Black)
                //close page
                
        }
        
        

    }
    
}

extension ComposeViewController:UITextViewDelegate{
    
    func textViewDidChange(textView: UITextView) {

        placceHolder.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        
    }


}
