//
//  UserAccount.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 13/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserAccount: NSObject, NSCoding {
    var access_token : String?
    var expires_in : NSNumber?{
        didSet{
            expires_date = NSDate(timeIntervalSinceNow: (expires_in?.doubleValue)!)
        
        }
    }
    var uid : String?
    var expires_date: NSDate?
    
    
    
    //user info
    var  screen_name: String?
    var avatar_image: String?
    
    
    override init(){
    
    
    }
    init(dict :[String : AnyObject]){
    
        access_token = dict["access_token"] as? String
        expires_in = dict["expires_in"] as? NSNumber
        uid = dict["uid"] as? String
        
    }

    override var description: String {
        let properties = ["access_token","expires_in","uid","screen_name","avatar_image"]
        let dict = self.dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    
    }
    
    
    
    //func loadUserInfo(finished: (account: UserAccount?, error:NSError?)->())
    func loadUserInfo(){
        
        print(#function)
            //assert(access_token==nil, "unauthorizaed")
            let path = "2/users/show.json"
            let params = ["access_token":access_token!,
                          "uid":uid!]
        NetWorkTools.sharedInstance().GET(path, parameters: params, success: {
                (_,JSON) -> Void in
               print(JSON)
            //check if the dictionary has values
            if let dict = JSON as? [String: AnyObject]{
            
                self.avatar_image = dict["avatar_large"] as? String
                self.screen_name = dict["screen_name"] as? String
                
                //archive account
                self.saveAccount()
                return
            }
            SVProgressHUD.showInfoWithStatus("Bad network connection...", maskType: SVProgressHUDMaskType.Black)

            
            }, failure: {
                (_,error) -> Void in
                print(error)
                SVProgressHUD.showInfoWithStatus("Bad network connection...", maskType: SVProgressHUDMaskType.Black)
        })
        
    }
    
    static let file_path = "account.plist".cacheDir() as String
    
    // MARK: -- save and load
    func saveAccount(){
        NSKeyedArchiver.archiveRootObject(self, toFile: "account.plist".cacheDir())
    }
    
    
    static var account:UserAccount?
    class func loadAccount()->UserAccount?{
        if account != nil{
            return account
        }
        account = NSKeyedUnarchiver.unarchiveObjectWithFile("account.plist".cacheDir()) as? UserAccount
        
        
        //check if the token expires
        if account?.expires_date?.compare(NSDate()) == NSComparisonResult.OrderedAscending{
        
            return nil
        }
        
        return account
        
    }
    
    // MARK: --NSCoding
    //write object to file
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_image, forKey: "avatar_image")
        
    
    }
    
    //read object from file
    required init?(coder aDecoder: NSCoder){
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        avatar_image = aDecoder.decodeObjectForKey("avatar_image") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    
    
    }
    
    //check if user has logined
    class func isLogin() ->Bool{
        return UserAccount.loadAccount() != nil
        
    }

}
