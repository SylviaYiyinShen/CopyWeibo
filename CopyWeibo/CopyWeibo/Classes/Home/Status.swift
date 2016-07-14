//
//  Status.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 14/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

class Status: NSObject {
    //date when the post created
    var created_at: String?
    
    //id for each post
    var id :Int = 0
    
    //content of the post
    var text :String?
    
    //sourece of the post
    var source :String?
    
    //array of all the pictures of the post
    var pic_urls: [[String: AnyObject]]?
    
    class func loadStatuses(finished: (models:[Status]?,error:NSError?)->()){
        
        let path = "2/statuses/home_timeline.json"
        let params = ["access_token":UserAccount.loadAccount()!.access_token!]
        
        
        NetWorkTools.sharedInstance().GET(path, parameters: params,
            success: { (_, JSON) in
            
            //get statuses array
            let models = dict2Model(JSON!["statuses"] as! [[String:AnyObject]])
            print(models)
            finished(models: models, error: nil)
            }) { (_, error) in
                print(error)
                finished(models: nil, error: error)
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
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        
    }
    
    
    
    //print dictionary
    var properties = ["created_at","id","text","source","pic_urls"]
    
    override var description: String{
        
        let dict = dictionaryWithValuesForKeys(properties)
        
        return "\(dict)"
    
    
    }
    
}
