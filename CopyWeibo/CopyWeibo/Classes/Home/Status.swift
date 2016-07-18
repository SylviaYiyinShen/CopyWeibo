//
//  Status.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 14/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit
import SDWebImage

class Status: NSObject {
    //date when the post created
    var created_at: String?{
        didSet{
            // created_at = "Sun Sep 12 14:50:57 +0800 2014"
            let createdDate = NSDate.dateWithStr(created_at!)
            created_at = createdDate.descDate
        }
    }
    //id for each post
    var id :Int = 0
    
    //content of the post
    var text :String?
    
    //sourece of the post
    var source :String?
        {
        didSet{
            print("source: \(source)")
            //should be trimmed  e.g.   <a href="sdfsdfsdf">Source</a>
            if let str = source{
                
            
                //let startLocation = (str as NSString).rangeOfString(">").location + 1
                //let length = (str as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startLocation
                //source = "from:" + (str as NSString).substringWithRange(NSMakeRange(startLocation, length))
            
            }
            
        }
    }
    
    //array of all the pictures of the post
    var pic_urls: [[String: AnyObject]]?{
        didSet{
            
            storedPicURLS = [NSURL]()
            
            //convert string to url, store in an array
            for dict in pic_urls!{
            
                if let urlStr = dict["thumbnail_pic"]{
                    storedPicURLS?.append(NSURL(string:urlStr as! String)!)
                    
                
                }
            
            }
        
        
        }
    }
    //url array of the imgs
    var storedPicURLS:[NSURL]?
    
    
    var user: User?
    
    
    class func loadStatuses(finished: (models:[Status]?,error:NSError?)->()){
        
        let path = "2/statuses/home_timeline.json"
        let params = ["access_token":UserAccount.loadAccount()!.access_token!]
        
        
        NetWorkTools.sharedInstance().GET(path, parameters: params,
            success: { (_, JSON) in
            
            //get statuses array
            let models = dict2Model(JSON!["statuses"] as! [[String:AnyObject]])
            print(models)
                
            //get chache images
            cacheStatusImages(models, finished: finished)
                
                
            //finished(models: models, error: nil)
                
                
            }) { (_, error) in
                print(error)
                finished(models: nil, error: error)
        }
    
    }
    
    class func cacheStatusImages(list:[Status],finished: (models:[Status]?,error:NSError?)->()){
        
        //check loaded thumbnail
        print("!!!!!=========".cacheDir())
        
        //create group
        let group = dispatch_group_create()
        
        
        
        for status in list{
            
            
            guard let urls = status.storedPicURLS else{
                
                continue
            }
            
            
            for imageURL in status.storedPicURLS!{
                
               
                
                
                //add to group
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(imageURL, options: SDWebImageOptions(rawValue:0), progress: nil, completed: { (_, _, _, _, _) in
                    print("---------completed")
                })
                //print(imageURL)
                //quit group
                dispatch_group_leave(group)
                
            }
    
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            //all the downloading thread have completed
            finished(models: list, error: nil)
            print("------------all completed")
        }
        
       
    
    }
    
    
    //convert status dictionary to model, store in a array
    class func dict2Model(list: [[String:AnyObject]])->[Status]{
        var models = [Status]()
        
        for dict in list{
                models.append(Status(dict: dict))
        
        }
        return models
    }
    
    
    //dictionary -> model object
    init(dict: [String :AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
        
    
    }
    
    
    //setValuesForKeysWithDictionary will call this function      
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if "user" == key{
            //user?.setValuesForKeysWithDictionary(value as! [String : NSObject])
            user = User(dict: value as! [String:AnyObject])
            return
            
        }
        super.setValue(value, forKey: key)
        
        
    }

    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        
    }
    
    
    
    //print dictionary
    var properties = ["created_at","id","text","source","pic_urls"]
    
    override var description: String{
        
        let dict = dictionaryWithValuesForKeys(properties)
        
        return "\(dict)"
    
    
    }
    
}
