//
//  NetWorkTools.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 12/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit
import AFNetworking

class NetWorkTools: AFHTTPSessionManager {
   // static var networkTools = NetWorkTools()
    static  let tools:NetWorkTools = {
        let url = NSURL(string: "https://api.weibo.com/")//must end with /
        let t = NetWorkTools(baseURL: url)
        
        //set acceptable type
        t.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/json","text/javascript","text/plain") as? Set<String>
        
        return t
        
    }()
    
    
    class func sharedInstance()->NetWorkTools{
        return tools
    
    }

}
