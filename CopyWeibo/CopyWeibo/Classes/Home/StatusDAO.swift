//
//  StatusDAO.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 3/08/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

//data access layer

class StatusDAO: NSObject {

    
    class func loadStatus(since_id:Int,max_id:Int, finished:([[String:AnyObject]]?,error:NSError?)->()){
        
        // load from local database
        loadCache(since_id, max_id: max_id){(array) -> () in
            
            
            // if statuses exist in local database, return the data
            if !array.isEmpty{
                finished(array,error:nil)
                return
            }
            
            
            let path = "2/statuses/home_timeline.json"
            var params = ["access_token":UserAccount.loadAccount()!.access_token!]
            
            //StatusDAO.loadCache(since_id, max_id: max_id)
            
            if since_id>0{
                params["since_id"] =  "\(since_id)"
            }
            
            if max_id>0{
                params["max_id"] = "\(max_id-1)"
                
            }
            
            
            
            
            
            
            // if not exist in local db, get remote data and store
            
            NetWorkTools.sharedInstance().GET(path, parameters: params,
                                              success: { (_, JSON) in
                
                let array = JSON!["statuses"] as! [[String:AnyObject]]
                
                cacheStatuses(array)
                
                finished(array,error: nil)
                                                
                                                
            }) { (_, error) in
                print(error)
                finished(nil,error:error)
            }

            
            

        }
    }

    
    //load cache in local database
    class func loadCache(since_id:Int,max_id:Int, finished:([[String:AnyObject]])->()){
        

        //compose sql
        var sql = "SELECT * FROM T_Status \n"
//        "where statusID > \n" + 
        
        
        if since_id>0{
            sql += "where statusID > \(since_id) \n"
        
        }else if max_id>0{
            sql += "where statusID < \(max_id) \n"
        }
        
        sql += "ORDER BY statusID DESC \n"
        sql += "LIMIT 20; \n"
        
        
        //execute sql
        SQLiteManager.shareManager().dbQueue?.inDatabase({ (db) in
            
            let results = db.executeQuery(sql, withArgumentsInArray: nil)
            var statuses = [[String:AnyObject]]()
            while results.next(){
                
                let dictStr = results.stringForColumn("statusText")
                let data = dictStr.dataUsingEncoding(NSUTF8StringEncoding)!
                let dict = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
                statuses.append(dict)
                
                //print(dictStr)
            }
            
            finished(statuses)
            print(statuses)
            
        })
    
    
    }
    
    class func cacheStatuses(statuses:[[String: AnyObject]]){
        

        
        
        
        let userID = UserAccount.loadAccount()!.uid!
        
        // 1.compose sql
        let sql = "INSERT INTO T_Status" +
            "(statusID, statusText,userID)" +
            "VALUES" +
            "(?,?,?);"
        
        // 2.execute sql
        
        SQLiteManager.shareManager().dbQueue?.inTransaction({ (db, rollback) -> Void in
            
            for dict in statuses{
                // data preparation
                let statusID = dict["id"]
                //JSON->BINARY->STRING
                let data = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
                let statusText = String(data:data,encoding: NSUTF8StringEncoding)
                
                if !db.executeUpdate(sql, statusID!, statusText!,userID)
                {
                    rollback.memory = true
                }
            }
            
            
        })

        
    
    
    
    }
    
}
