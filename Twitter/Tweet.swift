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
    var isRetweeted: Bool!
    var isFavoritedbyUser: Bool?
    var isRetweetedbyUser: Bool?
    
    var retweetUserScreenName: String?
    var user: String?
    var screenName: String?
    var userProfileImage: URL?
    var text: String?
    var timeStamp: Date?
    var repliesCount: Int64 = 0
    var retweetCount: Int64 = 0
    var favoritesCount: Int64 = 0
    
    var id: Int64!
    
    var shortTimeStamp: String
    {
        return DateFormatter.timeSince(from: timeStamp!)
    }
    
    var longTimeStamp: String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy, HH:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: timeStamp!)
    }
    
    init(_ dictionary: NSDictionary )
    {
        isRetweeted = (dictionary["retweeted_status"] == nil) ? false : true
        let tweetDict = (isRetweeted == true) ? dictionary["retweeted_status"] as! NSDictionary : dictionary

        //retweet user ScreenName is in the main dictionary, not in retweet status
        retweetUserScreenName = dictionary.value(forKeyPath: "user.name") as? String
        
        user = tweetDict.value(forKeyPath: "user.name") as? String
        screenName = tweetDict.value(forKeyPath: "user.screen_name") as? String
        let urlString = tweetDict.value(forKeyPath: "user.profile_image_url_https")
            as? String
        userProfileImage = URL(string: (urlString?.replacingOccurrences(of: "_normal", with: ""))!)

        let id_str = String(describing: tweetDict["id_str"]!)
        id = Int64(id_str)
        text = tweetDict["text"] as? String
        
        retweetCount = (tweetDict["retweet_count"] as! Int64)
        favoritesCount = (tweetDict["favorite_count"] as! Int64)
        isFavoritedbyUser = dictionary["favorited"] as? Bool
        isRetweetedbyUser = dictionary["retweeted"] as? Bool
        
        let timeStampString = tweetDict["created_at"]
        if let timeStampString = timeStampString
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.date(from: timeStampString as! String)
        }
    }
    
    class func tweetsWithArray(_ dictionaries: [NSDictionary]) -> [Tweet]
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
