//
//  HomeViewController.swift
//  TwitterDemo
//
//  Created by phuong le on 3/27/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var tweets:[Tweet] = []
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl.addTarget(self, action: "refreshControlAction", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        loadTweets(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    
    func refreshControlAction() {
        loadTweets(0)
    }

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let nav = segue.destinationViewController as! UINavigationController
        if nav.topViewController is TweetDetailsViewController {
            let vc = nav.topViewController as! TweetDetailsViewController
            let cell = sender as! TweetCell
            
            vc.tweet = tweets[tableView.indexPathForCell(cell)!.row]

        } else {
            let vc = nav.topViewController as! NewTweetViewController
            
            if(sender is UITableViewCell) {
                let cell = sender as! TweetCell
                let tweet = tweets[tableView.indexPathForCell(cell)!.row]
                vc.replyId = tweet.id
                vc.replyScreenName = tweet.screenName
            }
        }
        
    }

    
    @IBAction func backHomeTweet(segue: UIStoryboardSegue) {
        
        if segue.sourceViewController is TweetDetailsViewController {
        
            let vc = segue.sourceViewController as! TweetDetailsViewController
            self.updateTweetData(vc.tweet!)
            self.tableView.reloadData()
            
        } else {
            //let vc = segue.sourceViewController as! NewTweetViewController
            
        }
    }
    
    
    func loadTweets(page:Int){
        APIManager.instance().getTweetsHomeTimeLine(page, success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
            
                //print("tweet size: \(self.tweets.count)")
            
                self.refreshControl.endRefreshing()
            
            }) { (error: NSError) -> () in
                ViewControllerUtils.alert(self, title: "Data Load Fail", message: error.description)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCellWithIdentifier("TweetCell") as? TweetCell
        
        cell!.tweet = tweets[indexPath.row]
        cell!.delegate = self
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tweets.count
    }
    
    @IBAction func logoutHandler(sender: UIBarButtonItem) {
        APIManager.instance().logout()
    }
    
    func updateTweetData(newTweet:Tweet) {
        for index in 1...tweets.count {
            if tweets[index - 1].id! == newTweet.id! {
                tweets[index - 1] = newTweet
                print("update tweet data store: \(newTweet.id!)")
                return
            }
            
        }
    }
    
}

protocol tweetActionDelegate {
    func retweet(tweet:Tweet, sender:UITableViewCell)
    func reply(tweet:Tweet, sender:UITableViewCell)
    func favourite(tweet:Tweet, sender:UITableViewCell)
}

extension HomeViewController:tweetActionDelegate {
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
        
        self.performSegueWithIdentifier("NewTweetSegue", sender: self)
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
