//
//  LoginViewController.swift
//  TwitterDemo
//
//  Created by phuong le on 3/27/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginAction(sender: UIButton) {
        
        APIManager.instance().login({
            self.performSegueWithIdentifier("loginSegue", sender: self)
            }) {(error:NSError) in
                ViewControllerUtils.alert(self, title: "Login Fail", message: error.description)
        }

    }
}
