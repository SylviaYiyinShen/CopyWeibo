//
//  User.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 15/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

class User : NSObject{

    var id: Int = 0
    var name: String?
    var profile_image_url:String?{
        
        didSet{
            if let urlStr = profile_image_url{
                
                image_url = NSURL(string:urlStr)
            }
            
            
            
        }
    }
    var verified: Bool = false
    var verified_type: Int = -1{
        didSet{
            switch verified_type {
                case 0:
                    verifiedImage = UIImage(named: "avatar_vip")
                case 2,3,5:
                        verifiedImage = UIImage(named: "avatar_enterprise_vip")
                case 220:
                    verifiedImage = UIImage(named: "avatar_grassroot")
                default:
                    verifiedImage = nil
                
            }
            
        }
    }

    //store image url of the user
    var image_url: NSURL?
    
    var verifiedImage:UIImage?
    
    
    var mbrank : Int? = 0{// if not initialize 0, could not be allocated memory
        didSet{
            if mbrank>0 && mbrank<7{
                memberRankImage = UIImage(named: "common_icon_membership_level\(mbrank)")
                
            }
        }
 
    }
    var memberRankImage: UIImage?
    
    //dictionary -> model object
    init(dict: [String :AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
        
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
    //print dictionary
    var properties = ["id","name","profile_image_url","verified","verified_type"]
    
    override var description: String{
        
        let dict = dictionaryWithValuesForKeys(properties)
        
        return "\(dict)"
        
        
    }

}


