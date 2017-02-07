//
//  TweetsViewController.swift
//  Twitter
//
//  Created by daniel on 2/3/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()

        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) in
            
            for tweet in tweets
            {
                print(tweet.text)
            }
            
        }, failure: {
            
            (error: Error) in
            
            print(error)
        })
    }

    @IBAction func onLogout(_ sender: Any)
    {
       TwitterClient.sharedInstance?.logout()
    }

}
