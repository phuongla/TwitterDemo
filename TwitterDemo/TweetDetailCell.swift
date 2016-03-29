//
//  TweetDetailCell.swift
//  TwitterDemo
//
//  Created by phuong le on 3/30/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class TweetDetailCell: UITableViewCell {

    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var aliasLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var tweet:Tweet? {
        didSet {
            nameLabel.text = tweet!.name
            avatarImageView.setImageWithURL((tweet!.avatarUser)!)
            descLabel.text = tweet!.text
            aliasLabel.text = "@\(tweet!.screenName!)"
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd/yy, HH:mm"
            
            timeLabel.text = formatter.stringFromDate(tweet!.timestamp!)
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
