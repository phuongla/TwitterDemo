//
//  TweetDetailsViewController.swift
//  TwitterDemo
//
//  Created by phuong le on 3/29/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweet:Tweet? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.scrollEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    
        if segue.destinationViewController is UINavigationController {
        
            let nav = segue.destinationViewController as! UINavigationController
        
            if let vc = nav.topViewController as? NewTweetViewController {
                vc.replyId = tweet!.id!
                vc.replyScreenName = tweet!.screenName
            }
        }
    }


    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell:UITableViewCell
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetDetailCell") as! TweetDetailCell
            cell.tweet = tweet!
            returnCell = cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetCounterCell") as! TweetCounterCell
            cell.tweet = tweet!
            returnCell = cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetActionCell") as! TweetActionCell
            cell.tweet = tweet!
            cell.delegate = self
            returnCell = cell
        }
        
        returnCell.selectionStyle = .None
        
        return returnCell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    

}


extension TweetDetailsViewController:tweetActionDelegate {
    func retweet(tweet:Tweet, sender:UITableViewCell) {
        
        
        let isRetweeted = tweet.retweeted
        print("Retweet to: \(isRetweeted)")
        
        APIManager.instance().retweet(tweet.id!, retweet: isRetweeted, success: { (newTweet: Tweet) -> () in
            
            if sender is TweetCell{
                print("retweet success: \(newTweet.id!) : \(newTweet.retweeted)")
            }
            
            }) { (error: NSError) -> () in
                
                print("retweet error: \(error)")
                
                ViewControllerUtils.alert(self, title: "Retweet error", message: "Retweet error, please try again.")
        }
    }
    
    func reply(tweet:Tweet, sender:UITableViewCell) {
        
    }
    
    func favourite(tweet:Tweet, sender:UITableViewCell) {
        APIManager.instance().favoriteTweet(tweet.id!, favorite: tweet.favorited, success: { (newTweet: Tweet) -> () in
            
            if sender is TweetCell{
                print("favourite success: \(newTweet.id!) : \(newTweet.favorited)")
            }
            
            }) { (error: NSError) -> () in
                
                print("Favourite error: \(error)")
                
                ViewControllerUtils.alert(self, title: "Favourite error", message: "Favourite error, please try again.")
        }
    }
    
}
