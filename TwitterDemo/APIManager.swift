//
//  APIManager.swift
//  TwitterDemo
//
//  Created by phuong le on 3/27/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class APIManager: NSObject {
    
    static var _instance:APIManager?
    
    let ConsumerKey:String =  "QHldM3IQtYasw1XlnIgcr75BW"
    let ConsumerSecretKey:String = "QWDteTsLfyVTQSblcgRzvtrT5rJ4OejUESte4qQBUyscREZP1c"
    
    var token:String?
    var twitterClient:BDBOAuth1SessionManager?
    
    var loginSuccessCallback: (() -> ())?
    var loginFailCallback: ((NSError) -> ())?
    

    
    static func instance() -> APIManager{
        if _instance == nil {
            _instance = APIManager()
        }
        return _instance!
    }
    
    override init() {
        twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: ConsumerKey, consumerSecret: ConsumerSecretKey)
    }
    
    func login(success:() -> (), fail:(NSError) ->()) {
        
        loginSuccessCallback = success
        loginFailCallback = fail
        
        print("Request Login") 
        
        twitterClient!.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "myfirsttweet:/oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            
            
                let urlAuth = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
                UIApplication.sharedApplication().openURL(urlAuth!)
            
                print("Request token ok")
            
            }) { (error:NSError!) -> Void in
                print("error login: \(error)")
                
                self.loginFailCallback!(error)
        }
    }
    
    func getAccessTokenFromUrl(url:NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        print("getAccessTokenFromUrl")
        
        twitterClient!.fetchAccessTokenWithPath("oauth/access_token", method: "GET", requestToken: requestToken, success: { ( accessToken: BDBOAuth1Credential!) -> Void in
            
            print("I got access token: \(requestToken.token)")
            self.token = requestToken.token
            
            self.twitterClient!.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                    User.currentUser = User( data: response as! NSDictionary)
    
                    print("User: \(User.currentUser!.name)")
                    self.loginSuccessCallback!()
                
                }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("get credential error: \(error)")
                    self.loginFailCallback!(error)
            })
            
            
            }) { (error:NSError!) -> Void in
                print("error \(error)")
                self.loginFailCallback!(error)
        }
    }
    
    func getTweetsHomeTimeLine(page: Int, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        let params = ["page": page]
            
        twitterClient!.GET("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.parseTweets(dictionaries)
                success(tweets)
            
                }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                    failure(error)
            })
        
    }
    
    func logout() {
        User.currentUser = nil
        twitterClient! .deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func retweet(tweetId: String, retweet: Bool, success: (Tweet) -> (), failure: (NSError) -> ()) {
        let action: String = retweet ? "retweet" : "unretweet"

        print("API rt: \(tweetId) : \(retweet)")
        
        twitterClient!.POST("1.1/statuses/\(action)/\(tweetId).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
                let dictionary = response as! NSDictionary
                let tweet = Tweet(data: dictionary)
                success(tweet)
            }) { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        }
    }
    
    
    func favoriteTweet(tweetId: String, favorite: Bool, success: ((Tweet) -> ())?, failure: ((NSError) -> ())?) {
        let params = ["id": tweetId]
        let action: String = favorite ? "create" : "destroy"
        
        twitterClient!.POST("1.1/favorites/\(action).json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
                let dictionary = response as! NSDictionary
                let tweet = Tweet(data: dictionary)
                success?(tweet)
            }) { (task: NSURLSessionDataTask?, error: NSError) in
                failure?(error)
        }
    }
    
    func replyTweet(status: String, replyId: String, success: (Tweet) -> (), failure: (NSError) -> ()) {
        let params = ["status": status, "in_reply_to_status_id": replyId]
        twitterClient!.POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
                let dictionary = response as! NSDictionary
                let tweet = Tweet(data: dictionary)
                success(tweet)
            }) { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        }
    }
    
    
    func newTweet(status: String, success: (Tweet) -> (), failure: (NSError) -> ()) {
        let params = ["status": status]
        
        twitterClient!.POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(data: dictionary)
            success(tweet)
            }) { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        }
    }

}
