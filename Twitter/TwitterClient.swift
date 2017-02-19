//
//  TwitterClient.swift
//  Twitter
//
//  Created by daniel on 2/2/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager
{
    static let sharedInstance = TwitterClient(baseURL:URL(string:
        "https://api.twitter.com")!, consumerKey: "IeVCzKnOv7Vfn9Ptg3SNKPFih",
                                     consumerSecret: "7flqYmPq5cbdxwOfmTizyEjeIq0MLeiV8Z4ZZLGCVUwuy9caQF")
    
    var loginSucess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(sucess: @escaping ()->(), failure: @escaping (Error)->())
    {
        loginSucess = sucess
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "/oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: {
            
            (requestToken: BDBOAuth1Credential?) in
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }, failure: {
            
            (error: Error?) in
            
            self.loginFailure?(error!)
            print(error!.localizedDescription)
        })

    }
    
    func handleOpenUrl(_ url: URL)
    {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: {
            
            (accessToken: BDBOAuth1Credential?) in
            print("I got the access Token")
            
            self.currentAccount(success: { (user: User) in
                
                print("current User is being set in OPen URL")
                User.currentUser = user
                
                self.loginSucess?()
                
            }, failure: { (error: Error) in
                
                self.loginFailure?(error)
            })
            

            
        }, failure: { (error: Error?) in
            
            self.loginFailure?(error!)
            print(error!.localizedDescription)
        })
        

    }
    
    func logout()
    {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func homeTimeLine(max_id: Int64 = 0, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ())
    {
        
        let callParameters = max_id > 0 ? ["max_id" : max_id] : nil
        
        get("1.1/statuses/home_timeline.json", parameters: callParameters, progress: nil, success: {
            
            (task: URLSessionDataTask, response: Any?) -> Void in
            
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            success(tweets)
            
        }, failure: {
            
            (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
        })

    }
    
    func userTimeline(screen_name: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ())
    {
        get("1.1/statuses/user_timeline.json?screen_name=\(screen_name)", parameters: nil, progress: nil, success: {
            
            (task: URLSessionDataTask, response: Any?) -> Void in
            
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            success(tweets)
            
        }, failure: {
            
            (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
        })
    }
    
    func lookupUser(screen_name: String, success: @escaping (TwitterUser) -> (), failure: @escaping (Error) -> ())
    {
        get("1.1/users/lookup.json?screen_name=\(screen_name)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let user = TwitterUser((response as? Array<Any>)?[0] as! Dictionary<String, Any>)
            success(user)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
        }
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ())
    {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {
            
            (task: URLSessionDataTask, response: Any?) -> Void in
            
            let userDictionary = response as! Dictionary<String, Any>
            let user = User(userDictionary)
            success(user)
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func retweet(tweet id: Int64, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ())
    {
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweet = Tweet(response as! NSDictionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
        }
    }
    
    func unRetweet(tweet id: Int64, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ())
    {
        post("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweet = Tweet(response as! NSDictionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
        }
    }
    
    func favorite(tweet id: Int64, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ())
    {
        post("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweet = Tweet(response as! NSDictionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
        }
    }
    
    func unFavorite(tweet id: Int64, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ())
    {
        post("1.1/favorites/destroy.json?id=\(id)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweet = Tweet(response as! NSDictionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
        }
    }
    
    func updateStatus(tweet text: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ())
    {
        post("1.1/statuses/update.json", parameters: ["status": text], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweet = Tweet(response as! NSDictionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
        }
    }

}
