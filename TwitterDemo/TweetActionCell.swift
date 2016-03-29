//
//  TweetActionCell.swift
//  TwitterDemo
//
//  Created by phuong le on 3/30/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class TweetActionCell: UITableViewCell {

    
    @IBOutlet weak var retweetButton: UIButton!
   
    @IBOutlet weak var favouriteButton: UIButton!
    
    
    var tweet:Tweet? {
        didSet {
            changeFavouriteStyle()
            changeRetweetStyle()
        }
    }
    
    var delegate:tweetActionDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func retweetHandler(sender: UIButton){
        tweet!.retweeted = !tweet!.retweeted
        changeRetweetStyle()
        
        delegate!.retweet(tweet!, sender: self)
    }

    @IBAction func replyHandler(sender: UIButton) {
    }
    
    @IBAction func favouriteHandler(sender: UIButton) {
        
        tweet!.favorited = !tweet!.favorited
        changeFavouriteStyle()
        
        delegate!.favourite(tweet!, sender: self)
    }
    
    func changeRetweetStyle() {
        if tweet!.retweeted {
            let origImage = UIImage(named: "retweet")
            let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            retweetButton.setImage(tintedImage, forState: .Normal)
            retweetButton.tintColor = UIColor.greenColor()
            
        } else {
            let origImage = UIImage(named: "retweet")
            retweetButton.setImage(origImage, forState: .Normal)
        }
    }
    
    func changeFavouriteStyle() {
        if tweet!.favorited {
            let origImage = UIImage(named: "favorite")
            let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            favouriteButton.setImage(tintedImage, forState: .Normal)
            favouriteButton.tintColor = UIColor.redColor()
        } else {
            let origImage = UIImage(named: "favorite")
            favouriteButton.setImage(origImage, forState: .Normal)
        }
    }


}
