//
//  User.swift
//  TwitterDemo
//
//  Created by phuong le on 3/29/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class User: NSObject {
    
     static let userDidLogoutNotification = "UserDidLogout"
    
    var name:String?
    var screenName:String?
    var profileUrl:NSURL?
    var tagLine:String?
    var data:NSDictionary?
    
    init(data: NSDictionary) {
        
        self.data = data
        
        name = data["name"] as? String
        screenName = data["screen_name"] as? String
        
        let profileUrlString = data["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string:profileUrlString)
        }
        
        tagLine = data["description"] as? String
    }
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser  == nil {
        
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                if let userData = userData {
                    let dict = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(data: dict)
                }
            }
            return _currentUser

        }
        set(user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.data!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(user, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
