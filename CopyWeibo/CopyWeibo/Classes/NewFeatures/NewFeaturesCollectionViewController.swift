//
//  NewFeaturesCollectionViewController.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 14/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

private let CELL_IDENTIFIER = "reuseIdentifier"

class NewFeaturesCollectionViewController: UICollectionViewController {

    private var layout : UICollectionViewFlowLayout = NewFeatureLayout()
    private let pageCount = 4
    
    //no need to add "override", because the default init() is the one with arguments
    init(){
        super.init(collectionViewLayout:layout)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1. register cell
        collectionView?.registerClass(NewFeatureCell.self, forCellWithReuseIdentifier: CELL_IDENTIFIER)
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        layout.itemSize = UIScreen.mainScreen().bounds.size
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
//        //scroll 
//    
//        collectionView?.showsHorizontalScrollIndicator = false
//        collectionView?.bounces = false
//        collectionView?.pagingEnabled = true
        
    }
    
    // MARK: -- UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1. get cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as!  NewFeatureCell
        
        
        //2.se cel data
        //cell.backgroundColor =  UIColor.redColor()
        cell.imageIndex = indexPath.item
        //3. return cell
        
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        //print(indexPath)
        
        //get the current index
        let index = collectionView.indexPathsForVisibleItems().last!
        //get the current cell
        let cell = collectionView.cellForItemAtIndexPath(index) as! NewFeatureCell
        
        if index.item == pageCount-1{
        
            cell.startBtnAnimation()
        
        }
        
    
    }
    
    
    
}


class NewFeatureCell : UICollectionViewCell{

    //private, but could be accessed inside the file
    private var imageIndex:Int?{
    
        didSet{
            iconView.image =  UIImage(named: "new_feature_\(imageIndex!+1)")

        }
    }
    
    func startBtnAnimation(){
        
         startButton.hidden = false
        
        //animation for the button
        startButton.transform =  CGAffineTransformMakeScale(0.0, 0.0)
        startButton.userInteractionEnabled = false
        
        UIView.animateWithDuration(3.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue:0), animations: {()->Void in
            
            //clear the transform
            self.startButton.transform = CGAffineTransformIdentity
            
            }, completion: {(_)->Void in
                self.startButton.userInteractionEnabled = true
                
                
                
        })

    
    
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
    //1. add child view to the contentView
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        

        
        
        
    //2. set the layout of the child view
        iconView.xmg_Fill(contentView)
        startButton.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: contentView, size: nil,offset: CGPoint(x:0,y:-160))
    
    }

    
    func startBtnClicked(){
    
        print(#function)
        NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootViewControllerKey, object: true)
        
        //window?.rootViewController = MainViewController() -> AppDelegate
    
    }
    
    // MARK: lazy components
    private lazy var iconView = UIImageView()
    private lazy var startButton : UIButton = {
        
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named:"new_feature_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        btn.hidden = true
        
        
        // the class shoud not be private
        btn.addTarget(self, action: #selector(NewFeatureCell.startBtnClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    
    }()

}

private class NewFeatureLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout()
    {
        // 1. set layout
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 2.set content view
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }
}
