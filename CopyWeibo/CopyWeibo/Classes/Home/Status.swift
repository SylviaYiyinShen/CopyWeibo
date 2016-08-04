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
    
    //array of all thumbnails of the pictures of the post
    var pic_urls: [[String: AnyObject]]?{
        didSet{
            
            storedPicURLS = [NSURL]()
            storedLargePicURLS = [NSURL]()
            //convert string to url, store in an array
            for dict in pic_urls!{
            
                if let urlStr = dict["thumbnail_pic"] as? String{
                    //store thumbnail url
                    storedPicURLS?.append(NSURL(string:urlStr)!)
                    
                    //store large picture urls
                    let largeUrlStr = urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                    
                    storedLargePicURLS?.append(NSURL(string:largeUrlStr)!)
                }
            
            }
        
        
        }
    }
    //url array of the imgs
    var storedPicURLS:[NSURL]?//thumbnail
    var storedLargePicURLS:[NSURL]?//large picture
    
    
    var user: User?
    
    var retweeted_status: Status?
    var retweeted_storedPicURLS: [NSURL]?{
    
        return retweeted_status != nil ? retweeted_status?.storedPicURLS: storedPicURLS
    
    }
    var retweeted_storedLargePicURLS:[NSURL]?{
    
        return retweeted_status != nil ? retweeted_status?.storedLargePicURLS: storedLargePicURLS
    }
    
    class func loadStatuses(since_id:Int,max_id:Int,finished: (models:[Status]?,error:NSError?)->()){
        
        StatusDAO.loadStatus(since_id, max_id: max_id) { (array,error) in
            
            if array != nil{
                finished(models: nil, error: nil)
            }
            
            if error != nil{
                finished(models: nil, error: error)
            
            }
            
            //finished(models: array, error: nil)
            
            //get statuses array
            let models = dict2Model(array!)
            print(models)
            //get chache images
            cacheStatusImages(models, finished: finished)

        }
        
        /*
        let path = "2/statuses/home_timeline.json"
        var params = ["access_token":UserAccount.loadAccount()!.access_token!]
        
        //StatusDAO.loadCache(since_id, max_id: max_id)
        
        if since_id>0{
            params["since_id"] =  "\(since_id)"
        }
        
        if max_id>0{
            params["max_id"] = "\(max_id-1)"
        
        }
        
        NetWorkTools.sharedInstance().GET(path, parameters: params,
            success: { (_, JSON) in
            
            StatusDAO.cacheStatuses(JSON!["statuses"] as! [[String:AnyObject]])
            
            
            //get statuses array
            let models = dict2Model(JSON!["statuses"] as! [[String:AnyObject]])
            print(models)
                
            //get chache images
            cacheStatusImages(models, finished: finished)
                
                
            //finished(models: models, error: nil)
                
                
            }) { (_, error) in
                print(error)
                finished(models: nil, error: error)
        }*/
    
    }
    
    class func cacheStatusImages(list:[Status],finished: (models:[Status]?,error:NSError?)->()){
        
        //check loaded thumbnail in local folder
        //print("!!!!!=========".cacheDir())
        
        
        if list.count == 0 {
        
            finished(models: list, error: nil)
            return
        
        }
        
        
        //create group
        let group = dispatch_group_create()
        
        
        
        for status in list{
            
            
            guard (status.retweeted_storedPicURLS) != nil else{
                
                continue
            }
            
            
            for imageURL in status.retweeted_storedPicURLS!{
                
               
                
                
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
        
        //check if it is the retweeted 
        if "retweeted_status"  == key{
            retweeted_status =  Status(dict: value as! [String:AnyObject])
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
