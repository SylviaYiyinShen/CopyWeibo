//
//  PictureBrowserCell.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 22/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit
import SDWebImage


protocol PictureBrowserCellDelegate: NSObjectProtocol{

    func pictureBrowserCellDidClick(cell:PictureBrowserCell)
}
class PictureBrowserCell: UICollectionViewCell {
    
    weak var photoBrowserCellDelegate:PictureBrowserCellDelegate?
    
    var imageURL:NSURL?{
        didSet{
            resetScrollImage()
            
            //iconView.sd_setImageWithURL(imageURL)
            iconView.sd_setImageWithURL(imageURL) { (image, _, _, _) in
                /*let size = self.calculateSize(image)
                
                */
                
                
                //long picture
                self.setImagePosition()
 
            }
        }
    }
    
    
    
    private func setImagePosition(){
        //check long/normal picture, the height is greater than the height of screen
        
        let size = self.calculateSize(iconView.image!)
        
        //normal picture
        if size.height < UIScreen.mainScreen().bounds.height{
            iconView.frame = CGRect(origin:CGPointZero,size: size)
            let y = 0.5*(UIScreen.mainScreen().bounds.height - size.height)
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        
        }else{//long picture
            iconView.frame = CGRect(origin:CGPointZero,size: size)
            scrollView.contentSize = size
            
        
        }
    }
    
    private func calculateSize(image:UIImage)->CGSize{
        //let size = CGSize()
        
        let scale = image.size.height/image.size.width
        let width = UIScreen.mainScreen().bounds.width
        let height = width*scale
        
        //set image in the center
        
        return CGSize(width: width, height: height)
    }
    
    private func resetScrollImage(){
    
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentOffset = CGPointZero
        scrollView.contentSize = CGSizeZero
        
        iconView.transform = CGAffineTransformIdentity
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){

        contentView.addSubview(scrollView)
        scrollView.addSubview(iconView)
        
        scrollView.frame = UIScreen.mainScreen().bounds
        //activity.center = contentView.center
        

        scrollView.delegate = self
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.5
        
        //picture click listener
        let tap = UITapGestureRecognizer(target: self, action: #selector(PictureBrowserCell.clickToClose))
        iconView.addGestureRecognizer(tap)
        iconView.userInteractionEnabled = true
        
    
    
    }
    
    func clickToClose(){
        photoBrowserCellDelegate?.pictureBrowserCellDidClick(self)
    }
    
    //  MARK: --lazy components
    private lazy var scrollView : UIScrollView = UIScrollView()
    
    lazy var iconView : UIImageView = UIImageView()
}


extension PictureBrowserCell : UIScrollViewDelegate{
    
    //tell the system which components to zoom in
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        
        
        return iconView
    }
    
 
    //set the position after zooming
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        
        //view.bounds will not change, frame is the real size
        var offsetY = 0.5*(UIScreen.mainScreen().bounds.height - (view?.frame.height)!)
        var offsetX = 0.5*(UIScreen.mainScreen().bounds.width - view!.frame.width)
        offsetY = offsetY < 0 ? 0:offsetY
        offsetX = offsetX < 0 ? 0:offsetX
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)

    }


}
