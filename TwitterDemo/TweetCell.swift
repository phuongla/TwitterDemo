//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by phuong le on 3/27/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit


class TweetCell: UITableViewCell {

    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aliasLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favouriteCountLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    var delegate:tweetActionDelegate?
    
    var tweet:Tweet? {
        didSet {
            nameLabel.text = tweet!.name
            avatarImage.setImageWithURL((tweet!.avatarUser)!)
            descLabel.text = tweet!.text
            aliasLabel.text = "@\(tweet!.screenName!)"
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd/yy"
            
            timeLabel.text = formatter.stringFromDate(tweet!.timestamp!)
            
            retweetCountLabel.text = "\(tweet!.retweetCount.description)"
            
            favouriteCountLabel.text = "\(tweet!.favoritesCount)"
            
            changeFavouriteStyle()
            changeRetweetStyle()
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func replyHandler(sender: UIButton) {
        
        delegate!.reply(tweet!, sender: self)
    }

    @IBAction func retweet(sender: UIButton) {
        
        tweet!.retweeted = !tweet!.retweeted
        changeRetweetStyle()
        
        delegate!.retweet(tweet!, sender: self)
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
