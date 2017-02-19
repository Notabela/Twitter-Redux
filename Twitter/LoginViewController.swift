//
//  LoginViewController.swift
//  Twitter
//
//  Created by daniel on 1/31/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class LoginViewController: UIViewController
{
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(_ sender: Any)
    {
        
        TwitterClient.sharedInstance?.login(sucess: {
            
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            
        }, failure: {
            
            (error: Error) in
            
            print(error.localizedDescription)
        })
        
        /*
        
        //we create an AOuth Session Manager here with the necessary consumer
        //Key and Consumer Secret - baseurl here is just a convenience so we
        //don't have to type in the base URL everything we try to communicate
        
        let consumerKey = "IeVCzKnOv7Vfn9Ptg3SNKPFih"
        let consumerSecret = "7flqYmPq5cbdxwOfmTizyEjeIq0MLeiV8Z4ZZLGCVUwuy9caQF"
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: consumerKey, consumerSecret: consumerSecret)
        
        //Apparently there is a ubg in OAuth where things don't work unless we
        //logout first - clears the keychain of any access we might have had
        twitterClient?.deauthorize()
        
        //We now must prove to Twitter that we are who we say we are
        //we fetch a request token - the purpose is just to get a token
        //to send to that user
        
        //Regarding callbackURL - this is the 'url' the client will call back to
        //so like http:// will look at http and open a browser, what matters here
        //really is the twitterdemo not the ://oauth just like a website.
        //so the phone will try to look for clients that can open twitterdemo objects
        
        //and we have to register our App with this url - so in the app settings -> Info
        //register our app identifier for twitterdemo url types
        //And when the app is opened with the call back url, it will run the appDelegate
        //function application openURL
        twitterClient?.fetchRequestToken(withPath: "/oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: {
            
            (requestToken: BDBOAuth1Credential?) in

            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }, failure: {
            
            (error: Error?) in
            
            print(error!.localizedDescription)
        })
 */
    }

}
