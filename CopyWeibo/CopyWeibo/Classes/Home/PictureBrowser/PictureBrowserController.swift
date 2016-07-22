//
//  PictureBrowserControllerCollectionViewController.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 21/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit
import SVProgressHUD

private let PictureCellID = "PictureCellID"


class PictureBrowserController: UIViewController {
    
    var currentIndex:Int?
    var pictureURLs:[NSURL]?
    
    init(currentIndex:Int,pictureURLs:[NSURL]){
        
        //must initialize before super.init()
        self.currentIndex = currentIndex
        self.pictureURLs = pictureURLs
        
        super.init(nibName: nil, bundle: nil)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setupUI()
        
    }
    
    private func setupUI(){
        
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        
        
        closeButton.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize(width:100,height:35),offset: CGPoint(x:10,y:-10))
        
        saveButton.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: view, size: CGSize(width:100,height:35),offset: CGPoint(x:-10,y:-10))
    
        collectionView.frame = UIScreen.mainScreen().bounds
        
        collectionView.dataSource = self
        collectionView.registerClass(PictureBrowserCell.self, forCellWithReuseIdentifier: PictureCellID)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: --lazy components
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.darkGrayColor()
        
        button.addTarget(self, action: #selector(PictureBrowserController.closeButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.darkGrayColor()
        button.addTarget(self, action: #selector(PictureBrowserController.saveButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame:CGRectZero,collectionViewLayout:PictureBrowserLayout() )
    
    func closeButtonClicked(){
    
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveButtonClicked(){
        let index = collectionView.indexPathsForVisibleItems().last!
        let cell = collectionView.cellForItemAtIndexPath(index) as! PictureBrowserCell
        
        let image = cell.iconView.image
        UIImageWriteToSavedPhotosAlbum(image!, self,#selector(PictureBrowserController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject){
        if error != nil{
            SVProgressHUD.showErrorWithStatus("Failed to save picture", maskType: SVProgressHUDMaskType.Black)
        }else{
            SVProgressHUD.showSuccessWithStatus("Succeed to save piture", maskType: SVProgressHUDMaskType.Black)
        
        }
    }
}

extension PictureBrowserController:UICollectionViewDataSource, PictureBrowserCellDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pictureURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PictureCellID, forIndexPath: indexPath) as! PictureBrowserCell
        cell.backgroundColor =  UIColor.redColor()
        cell.imageURL = pictureURLs![indexPath.item]
        
        cell.photoBrowserCellDelegate = self
        return cell
    }
    
    func pictureBrowserCellDidClick(cell: PictureBrowserCell) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

}


class PictureBrowserLayout : UICollectionViewFlowLayout{

    override func prepareLayout() {
        itemSize = UIScreen.mainScreen().bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
    }
    

}
