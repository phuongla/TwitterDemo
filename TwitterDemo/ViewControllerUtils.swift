//
//  ViewControllerUtils.swift
//  ParseChatSample
//
//  Created by phuong le on 3/23/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class ViewControllerUtils: NSObject {

    static func alert(viewController:UIViewController, title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert);
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
            
        }
        
        alertController.addAction(okAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
}
