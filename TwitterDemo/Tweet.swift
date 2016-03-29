//
//  Tweet.swift
//  TwitterDemo
//
//  Created by phuong le on 3/29/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: String?
    var timestamp: NSDate?
    var retweetCount = 0
    var favoritesCount = 0
    var favorited: Bool = false
    var retweeted: Bool = false
    var id: String?
    
    var name: String?
    var screenName: String?
    var avatarUser: NSURL?
    
    var retweetedStatusScreenName: String?
    
    init(data: NSDictionary) {
        
        text = data["text"] as? String
        retweetCount = (data["retweet_count"] as? Int) ?? 0
        favoritesCount = (data["favourites_count"] as? Int) ?? 0
        id = data["id_str"] as? String
        favorited = data["favorited"] as? Bool ?? false
        retweeted = data["retweeted"] as? Bool ?? false
        
        if let retweetStatus = data["retweeted_status"] {
            retweetedStatusScreenName = data["user"]?["name"] as? String
            if let avatar = retweetStatus["user"]?!["profile_image_url"] as? String {
                let avatarUrl = NSURL(string: avatar)
                avatarUser = avatarUrl
            }
            name = retweetStatus["user"]?!["name"] as? String
            screenName = retweetStatus["user"]?!["screen_name"] as? String
        } else {
            name = data["user"]?["name"] as? String
            screenName = data["user"]?["screen_name"] as? String
            if let avatar = data["user"]?["profile_image_url"] as? String {
                let avatarUrl = NSURL(string: avatar)
                avatarUser = avatarUrl
            }
        }
        
        let timestampString = data["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
        
    }
    
    static func parseTweets(dicts: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for data in dicts {
            let tweet = Tweet(data: data)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
