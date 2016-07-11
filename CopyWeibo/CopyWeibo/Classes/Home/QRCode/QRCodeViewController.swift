//
//  QRCodeViewController.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 11/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController , UITabBarDelegate{
    
    @IBOutlet weak var tabBar: UITabBar!
    
    
    //top constraint of the scanline
    @IBOutlet weak var scanLineTopCons: NSLayoutConstraint!
    
    //constraint of height of the container
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    

    @IBOutlet weak var qrcodeView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //select the right item by default
        tabBar.selectedItem = tabBar.items![0]
        tabBar.delegate =  self
    }
    

    
    @IBAction func closeBtnClick(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.scanLineTopCons.constant = -self.containerHeightCons.constant
        //self.qrcodeView.layoutIfNeeded()
        
        //display animation( should not be implemented in viewDidload because of the childview )
        
        UIView.animateWithDuration(5.0, animations: {() -> Void in
                //1. update the constaints
                self.scanLineTopCons.constant = self.containerHeightCons.constant
                UIView.setAnimationRepeatCount(MAXFLOAT)
                //2. update the view
                self.qrcodeView.layoutIfNeeded()
            
            
            })
    }
    
    
    // MARK: -- tabbar
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
         print(item.tag)
        if item.tag == 1{//qrcode
            self.containerHeightCons.constant = 300
        
        }else{//barcode
            self.containerHeightCons.constant = 150
            
        
        }
        
       
        
    }

}
