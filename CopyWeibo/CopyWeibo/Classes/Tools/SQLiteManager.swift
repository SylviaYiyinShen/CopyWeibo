//
//  SQLiteManager.swift
//  01-FMDB基本使用
//
//  Created by xiaomage on 15/9/21.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit

class SQLiteManager: NSObject {
    
    private static let manager: SQLiteManager = SQLiteManager()
    class func shareManager() -> SQLiteManager {
        return manager
    }
    
    var dbQueue: FMDatabaseQueue?
    

    func openDB(DBName: String)
    {

        let path = DBName.docDir()
        print(path)
        
        //if using FMDatabaseQueue, no need to open db, opening is included in init
        dbQueue = FMDatabaseQueue(path: path)

        creatTable()
    }
    
    private func creatTable()
    {
     
        print(#function)
        /*table designing
            statusID, statusJSON, userID
        */
        
        // 1.编写SQL语句
        let sql = "CREATE TABLE IF NOT EXISTS T_Status( \n" +
            "statusID INTEGER PRIMARY KEY, \n" +
            "statusText TEXT, \n" +
            "userID INTEGER \n" +
        "); \n"
        
        
        
        // execute sql
        dbQueue!.inDatabase { (db) -> Void in
            db.executeUpdate(sql, withArgumentsInArray: nil)
        }
        /*
        dbQueue?.inDatabase({ (db) in
            db.executeUpdate(sql, withArgumentsInArray: nil)
        })*/
    }
}
