//
//  OAuthViewController.swift
//  CopyWeibo
//
//  Created by Yiyin Shen on 12/07/2016.
//  Copyright © 2016 Yiyin Shen. All rights reserved.
//

import UIKit
import SVProgressHUD


class OAuthViewController: UIViewController {

    let APP_KEY = "3611111358"
    let SECRET_KEY = "314edd52bc91ab3f137bffb54137add5"
    let REDIRECT_URL = "http://www.weibo.com"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //o set navigation bar
        navigationItem.title = "My Weibo"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(OAuthViewController.closeBtnClick))
        

        //1. unauthorized token
        //need to modify info.plist allow arbitrary loads
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(APP_KEY)&redirect_uri=\(REDIRECT_URL)"
        let url = NSURL(string:urlString)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
        //2. authorized token
       
        
    }
    
    
    
    // MARK: - for better user experence
    func webViewDidStartLoad(webView: UIWebView) {
        //
        SVProgressHUD.showInfoWithStatus("Loading...",maskType: SVProgressHUDMaskType.Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    
    
    func closeBtnClick(){
    
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    override func loadView() {
        view = webView
    }
    
    // MARK: --
    private lazy var webView:UIWebView = {
        let webView = UIWebView()
        webView.delegate = self
        return webView
    
    
    
    }()

 }

extension OAuthViewController : UIWebViewDelegate{


    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        print(request.URL?.absoluteString)
        
        let urlString = request.URL?.absoluteString
        //1 check if it is  authorize url
        if !(urlString!.hasPrefix(REDIRECT_URL)){
        
        
            return true
        }
        
        
        //2. check success, request.URL.query -> code=?????/
        let codeString = "code="
        if request.URL!.query!.hasPrefix(codeString){
            
            //1.get code token
            let code = request.URL?.query?.substringFromIndex(codeString.endIndex)
            print(code)
            
            //2. get access token
            loadAccessToken(code!)
        
        }else{
        //cancel the authorization, close the page
            print("cancel authorization")
            closeBtnClick()
        
        }
        
        return false
        
        
    }

    
    //authorized code
   private func loadAccessToken(code:String){
        //let path = "oauth2/access_token"
//        let params = ["client_id":APP_KEY,
//                        "client_secret":SECRET_KEY,
//                        "grant_type":"authorization_code",
//                        "code":code,
//                        "redirect_uri":REDIRECT_URL]
//        
//        print("====url=========")
//
//        NetWorkTools.sharedInstance().POST(path, parameters: params, success: {
//            
//            (_,JSON)-> Void in
//                    print(JSON)
//            }, failure: {(_,error) -> Void in
//                
//                print(error)
//        
//        })
        let path = "oauth2/access_token?client_id=\(APP_KEY)&client_secret=\(SECRET_KEY)&grant_type=authorization_code&code=\(code)&redirect_uri=\(REDIRECT_URL)"
        //let params = ["client_id":APP_KEY, "client_secret":SECRET_KEY, "grant_type":"authorization_code", "code":code, "redirect_uri":REDIRECT_URL]

        NetWorkTools.sharedInstance().POST(path, parameters: nil, success: { (_, JSON) -> Void in
            print(JSON)
            //access token-> 2.00BMks7GaBr4wD74092aab3aCuUkLB
            print(NSDate(timeIntervalSinceNow: 157679999))
            let account = UserAccount(dict:JSON as! [String : AnyObject])
            print(account)

            //get user info
            //finished(account:self,error:nil)
            
            account.loadUserInfo()
            
        }) { (_, error) -> Void in
            print(error)
        }
       
    
    
    }

}