//
//  String+Category.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 13/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit

extension String{

    
    //append the string to the cache directory path
    func cacheDir()->String{
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    
    }
    
    //append the string to the documents directory path
    func docDir()->String{
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    
    
    }

    
    //append the string to the temp directory path
    func tmpDir()->String{
        let path = NSTemporaryDirectory() as NSString
        
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    
    }

}
