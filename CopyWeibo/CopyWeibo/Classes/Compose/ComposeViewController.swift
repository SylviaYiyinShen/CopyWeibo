//
//  ComposeViewController.swift
//  DSWeibo
//
//  Created by xiaomage on 15/9/16.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {
    

    /// 图片选择器
    private lazy var photoPickerVC: PhotoPickerViewController = PhotoPickerViewController()
    
    /// 工具条底部约束
    var toolbarBottonCons: NSLayoutConstraint?
    /// 图片选择器高度约束
    var photoViewHeightCons: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        // 0.注册通知监听键盘弹出和消失
        NSNotificationCenter.defaultCenter().addObserver(self , selector: "keyboardChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // 1.将键盘控制器添加为当前控制器的子控制器
        addChildViewController(photoPickerVC)
        
        // 1.初始化导航条
        setupNav()
        // 2.初始化输入框
        setupInpuView()
        // 3.初始化图片选择器
        setupPhotoView()
        // 3.初始化工具条
        setupToolbar()
    }
    
    /**
    只要键盘改变就会调用
     
    */
    func keyboardChange(notify: NSNotification)
    {
        print(notify)
        // 1.取出键盘最终的rect
        let value = notify.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rect = value.CGRectValue()

        // 2.修改工具条的约束
        // 弹出 : Y = 409 height = 258
        // 关闭 : Y = 667 height = 258
        // 667 - 409 = 258
        // 667 - 667 = 0
        let height = UIScreen.mainScreen().bounds.height
        toolbarBottonCons?.constant = -(height - rect.origin.y)
        
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
        
        let anim = toolbar.layer.animationForKey("position")
        print("duration = \(anim?.duration)")
        
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if photoViewHeightCons?.constant == 0
        {
            // 主动召唤键盘
            textView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 主动隐藏键盘
        textView.resignFirstResponder()
    }
    private func setupToolbar()
    {
        // 1.添加子控件
        view.addSubview(toolbar)
        
        // 2.添加按钮
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
        items.removeLast()
        toolbar.items = items
        
        // 3布局toolbar
        let width = UIScreen.mainScreen().bounds.width
        let cons = toolbar.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize(width: width, height: 44))
        toolbarBottonCons = toolbar.xmg_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
    }
    
    /**
    选择相片
    */
    func selectPicture()
    {
        // 1.关闭键盘
        textView.resignFirstResponder()
        
        // 2.调整图片选择器的高度
        photoViewHeightCons?.constant = UIScreen.mainScreen().bounds.height * 0.6
    }
    
    func setupPhotoView()
    {
        // 1.添加图片选择器
        view.insertSubview(photoPickerVC.view, belowSubview: toolbar)
        
        // 2.布局图片选择器
        let size = UIScreen.mainScreen().bounds.size
        let widht = size.width
        let height: CGFloat = 0 // size.height * 0.6
        let cons = photoPickerVC.view.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize(width: widht, height: height))
        photoViewHeightCons = photoPickerVC.view.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }
    
    
    /**
    初始化输入视图
    */
    private func setupInpuView()
    {
        // 1.添加子控件
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        // 2.布局子控件
        textView.xmg_Fill(view)
        placeholderLabel.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: textView, size: nil, offset: CGPoint(x: 5, y: 8))
    }

    /**
    初始化导航条
    */
    private func setupNav()
    {
        // 1.添加左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        
        // 2.添加右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        navigationItem.rightBarButtonItem?.enabled = false
        
        // 3.添加中间视图
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        let label1 = UILabel()
        label1.text = "Post status"
        label1.font = UIFont.systemFontOfSize(15)
        label1.sizeToFit()
        titleView.addSubview(label1)
        
        let label2 = UILabel()
        label2.text = UserAccount.loadAccount()?.screen_name
        label2.font = UIFont.systemFontOfSize(13)
        label2.textColor = UIColor.darkGrayColor()
        label2.sizeToFit()
        titleView.addSubview(label2)
        
        label1.xmg_AlignInner(type: XMG_AlignType.TopCenter, referView: titleView, size: nil)
        label2.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: titleView, size: nil)
        
        navigationItem.titleView = titleView
    }
    
    /**
    关闭控制器
    */
    func close()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
    发送文本微博
    */
    func sendStatus()
    {
        
        let path = "2/statuses/update.json"
        let params = ["access_token":UserAccount.loadAccount()!.access_token! , "status": textView.text]
        if let image = photoPickerVC.pictureImages.first
        {
            // 发送图片微博
            let path = "2/statuses/upload.json"
            let params = ["access_token":UserAccount.loadAccount()!.access_token! , "status": textView.text]
            NetWorkTools.sharedInstance().POST(path, parameters: params, constructingBodyWithBlock: { (formData) -> Void in
                // 1.将数据转换为二进制
                let data = UIImagePNGRepresentation(image)
                
                // 2.上传数据
                /*
                 第一个参数: 需要上传的二进制数据
                 第二个参数: 服务端对应哪个的字段名称
                 第三个参数: 文件的名称(在大部分服务器上可以随便写)
                 第四个参数: 数据类型, 通用类型application/octet-stream
                 */
                formData.appendPartWithFileData(data!
                    , name:"pic", fileName:"abc.png", mimeType:"application/octet-stream");
                
                }, success: { (_, JSON) -> Void in
                    // 1.提示用户发送成功
                    SVProgressHUD.showSuccessWithStatus("发送成功", maskType: SVProgressHUDMaskType.Black)
                    // 2.关闭发送界面
                    self.close()
                    
                }, failure: { (_, error) -> Void in
                    print(error)
                    // 3.提示用户发送失败
                    SVProgressHUD.showErrorWithStatus("发送失败", maskType: SVProgressHUDMaskType.Black)
            })
        }else
        {
            // 发送文字微博
            let path = "2/statuses/update.json"
            let params = ["access_token":UserAccount.loadAccount()!.access_token! , "status": textView.text]
            NetWorkTools.sharedInstance().POST(path, parameters: params, success: { (_, JSON) -> Void in
                
                // 1.提示用户发送成功
                SVProgressHUD.showSuccessWithStatus("发送成功", maskType: SVProgressHUDMaskType.Black)
                // 2.关闭发送界面
                self.close()
            }) { (_, error) -> Void in
                print(error)
                // 3.提示用户发送失败
                SVProgressHUD.showErrorWithStatus("发送失败", maskType: SVProgressHUDMaskType.Black)
            }
        }

    }
    
    // MARK: - 懒加载
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFontOfSize(20)
        tv.delegate = self
        return tv
    }()
    
    private lazy var placeholderLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor.darkGrayColor()
        label.text = "Share your ideas..."
        return label
    }()
    
    private lazy var toolbar: UIToolbar = UIToolbar()
}

extension ComposeViewController: UITextViewDelegate
{
    func textViewDidChange(textView: UITextView)
    {
        // 注意点: 输入图片表情的时候不会促发textViewDidChange
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
}
