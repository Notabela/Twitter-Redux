//
//  Tweet.swift
//  Twitter
//
//  Created by daniel on 2/2/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit

class Tweet: NSObject
{
    var text: String?
    var timeStamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    init(_ dictionary: Dictionary<String, Any>)
    {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourties_count"] as? Int) ?? 0
        
        let timeStampString = dictionary["created_at"]
        
        if let timeStampString = timeStampString
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.date(from: timeStampString as! String)
        }
    }
    
    class func tweetsWithArray(_ dictionaries: [Dictionary<String, Any>]) -> [Tweet]
    {
        var tweets = [Tweet]()
        
        for dict in dictionaries
        {
            let tweet = Tweet(dict)
            tweets.append(tweet)
        }
        
        return tweets
    }

}
