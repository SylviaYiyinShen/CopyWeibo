//
//  StatusTableViewPictureView.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 18/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

class StatusTableViewPictureView: UICollectionView {
    
    var status:Status?{
        didSet{
            reloadData()
      
        }
    
    }
    //picture view
    private var pictureLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    
    init() {
        super.init(frame: CGRectZero, collectionViewLayout: pictureLayout)
        setupPictureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupPictureView(){
        registerClass(PictureViewCell.self, forCellWithReuseIdentifier: PICTURE_CELL_ID)
        dataSource = self
        
        //set margin of the cells
        pictureLayout.minimumInteritemSpacing = 10
        pictureLayout.minimumLineSpacing = 10
        
        backgroundColor = UIColor.whiteColor()
        
        
    }
    
    
    
    //calculate size of the pictures
    func calculateImageSize() -> CGSize{
        //1. get number of the images
        let count = status?.storedPicURLS?.count
        
        
        //2. no picture return zero
        if count == 0 || count  == nil {
            return CGSizeZero
            
        }
        
        //3. 1 picture-> real size
        if count == 1 {
            //
            //            let key = status?.storedPicURLS!.first?.absoluteString
            //            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
            //
            //            return (image.size,image.size)
            //
            //            let key = status?.storedPicURLS!.first?.absoluteString
            //            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
            //
            //            return (image.size,image.size)
        }
        //4. 4 pictures-> size of cross pattern
        let width = 90
        let margin = 10
        pictureLayout.itemSize = CGSize(width: width, height: width)
        if count == 4 {
            
            let viewWidth = width*2 + margin
            
            return CGSize(width: viewWidth, height: viewWidth)
            
        }
        
        
        
        
        //5. more than 4 pictures size of nine-cell pattern
        
        let colNumber = 3
        let rowNumber = (count! - 1) / 3 + 1
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        
        return CGSize(width: viewWidth, height: viewHeight)
    }
    
    
    // MARK: PictureViewCell
    private class PictureViewCell: UICollectionViewCell{
        
        var imageUrl: NSURL?{
            
            didSet{
                iconImageView.setImageWithURL(imageUrl!)
                
            }
            
            
        }
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setupUI()
        }
        
        // MARK: -cell lazy load
        private lazy var iconImageView:UIImageView = UIImageView()
        
        private func setupUI(){
            contentView.addSubview(iconImageView)
            iconImageView.xmg_Fill(contentView)
            
            
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    

  
}


extension StatusTableViewPictureView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.storedPicURLS?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1.get cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PICTURE_CELL_ID, forIndexPath: indexPath) as! PictureViewCell
        //2. set data
        //cell.backgroundColor = UIColor.greenColor()
        cell.imageUrl = status?.storedPicURLS![indexPath.item]
        //3. return
        return cell
        
        
    }
}


