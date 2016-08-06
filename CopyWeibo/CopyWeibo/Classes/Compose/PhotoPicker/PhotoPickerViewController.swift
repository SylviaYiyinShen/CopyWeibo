//
//  PhotoPickerViewController.swift
//  PhotoPicker
//
//  Created by Yiyin Shen on 4/08/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

private let PHOTO_PICKER_CELL_ID = "photo picker cell id"

class PhotoPickerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    private func setupUI(){
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collcetionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collcetionView": collectionView])
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collcetionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collcetionView": collectionView])
        view.addConstraints(cons)
        
        

    }
    
    
    // MARK: --lazy component
    


    private lazy var collectionView: UICollectionView = {
    
        let view = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoPickerViewLayout())
        view.dataSource = self
        
        view.registerClass(PhotoPickerCell.self, forCellWithReuseIdentifier: PHOTO_PICKER_CELL_ID)
        
        return view
    }()

    lazy var pictureImages = [UIImage]()

}


extension  PhotoPickerViewController: UICollectionViewDataSource,PhotoPickerCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pictureImages.count+1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PHOTO_PICKER_CELL_ID, forIndexPath: indexPath) as! PhotoPickerCell
        cell.backgroundColor = UIColor.greenColor()
        cell.photoCellDelegate = self
        cell.image = (pictureImages.count == indexPath.item) ? nil : pictureImages[indexPath.item]
        return cell
        
    }
    
    func didAddPhoto(cell: PhotoPickerCell) {
        print(#function)
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            
            print("Failed to open photo library")
            return
        }
        let vc = UIImagePickerController()
        vc.delegate = self
//        vc.allowsEditing
        presentViewController(vc, animated: true, completion: nil)
    
    }
    func didRemovePhoto(cell: PhotoPickerCell) {
        let indexPath = collectionView.indexPathForCell(cell)
        pictureImages.removeAtIndex(indexPath!.item)
        collectionView.reloadData()
    
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        
        //generate smaller picture
        let newImage = image.imageWithScale(300)
        
        pictureImages.append(newImage)
        
        
        
        
        
        
        
        collectionView.reloadData()
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}



class PhotoPickerViewLayout: UICollectionViewFlowLayout{


    override func prepareLayout() {
        super.prepareLayout()
        itemSize = CGSize(width: 80,height: 80)
        minimumLineSpacing = 10
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    
    }


}

@objc
protocol PhotoPickerCellDelegate : NSObjectProtocol
{
    optional func didAddPhoto(cell: PhotoPickerCell)
    optional func didRemovePhoto(cell: PhotoPickerCell)
}


class PhotoPickerCell : UICollectionViewCell{

    weak var photoCellDelegate: PhotoPickerCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    var image: UIImage?
        {
        didSet{
            if image != nil{
                removeButton.hidden = false
                addButton.setBackgroundImage(image!, forState: UIControlState.Normal)
                addButton.userInteractionEnabled = false
            }else
            {
                removeButton.hidden = true
                addButton.userInteractionEnabled = true
                addButton.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
            }
        }
    }
    
    private func setupUI(){
    
        // 1.添加子控件
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        
        // 2.布局子控件
        addButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addButton": addButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addButton": addButton])
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:[removeButton]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton": removeButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-2-[removeButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton": removeButton])
        
        contentView.addConstraints(cons)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: CELL COMPONENT
    private lazy var removeButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "compose_photo_close"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(PhotoPickerCell.removeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    private lazy  var addButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(PhotoPickerCell.addBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    func addBtnClick()
    {
        //
        photoCellDelegate?.didAddPhoto!(self)
    }
    
    func removeBtnClick()
    {
        //        print(__FUNCTION__)
        photoCellDelegate?.didRemovePhoto!(self)
    }

}









