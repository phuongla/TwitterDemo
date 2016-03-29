//
//  NewTweetViewController.swift
//  TwitterDemo
//
//  Created by phuong le on 3/30/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aliasLabel: UILabel!
    
    @IBOutlet weak var tweetTextBox: UITextField!
    
    
    
    var replyId:String?
    var replyScreenName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
        
    }
    
    func loadData() {
        avatarImage.setImageWithURL(User.currentUser!.profileUrl!)
        
        nameLabel.text = User.currentUser!.name
        aliasLabel.text = User.currentUser!.screenName
        
        if replyScreenName != nil {
            tweetTextBox.text = "@\(replyScreenName!)"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
       
        tweetTextBox.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tweetHandler(sender: UIBarButtonItem) {
        
        let text = tweetTextBox.text
        
        if (text!.isEmpty) {
            ViewControllerUtils.alert(self, title: "Input required", message: "Please input tweet content")
            return
        }
        
        if replyId != nil {
            
            APIManager.instance().replyTweet(text!, replyId: replyId!, success: { (tweet: Tweet) -> () in
                
                    ViewControllerUtils.alert(self, title: "Tweet Success", message: "Post tweet success.")
                
                
                }, failure: { (error: NSError) -> () in
                    ViewControllerUtils.alert(self, title: "Tweet Erorr", message: "Post tweet error, please try again")
            })
            
        } else {
            APIManager.instance().newTweet(text!, success: { (tweet: Tweet) -> () in
                
                ViewControllerUtils.alert(self, title: "Tweet Success", message: "Post tweet success.")
                
                }, failure: { (error: NSError) -> () in
                    ViewControllerUtils.alert(self, title: "Tweet Erorr", message: "Post tweet error, please try again")
            })

        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
