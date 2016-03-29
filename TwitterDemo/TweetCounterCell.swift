//
//  TweetCounterCell.swift
//  TwitterDemo
//
//  Created by phuong le on 3/30/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class TweetCounterCell: UITableViewCell {
    
    
    @IBOutlet weak var tweetCountLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var tweet:Tweet? {
        didSet{
            tweetCountLabel.text = "\(tweet!.retweetCount)"
            
            likeCountLabel.text = "\(tweet!.favoritesCount)"
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

}
