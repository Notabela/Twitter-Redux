//
//  TwitterUser.swift
//  Twitter
//
//  Created by daniel on 2/2/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit

class TwitterUser: NSObject
{
    var name: String?
    var screenName: String?
    var location: String?
    var userDescription: String?
    var followers: Int64?
    var following: Int64?
    var profileImageUrl: URL?
    var profileCoverImageUrl: URL?

    
    init(_ dictionary: Dictionary<String, Any>)
    {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        location = dictionary["location"] as? String
        userDescription = dictionary["description"] as? String
        followers = dictionary["followers_count"] as? Int64
        following = dictionary["friends_count"] as? Int64
        
        if let profileUrlString = dictionary["profile_image_url_https"] as? String
        {
            profileImageUrl = URL(string: (profileUrlString.replacingOccurrences(of: "_normal", with: "")))
        }
        
        if let profileCoverUrlString = dictionary["profile_background_image_url_https"] as? String
        {
            profileCoverImageUrl = URL(string: (profileCoverUrlString.replacingOccurrences(of: "_normal", with: "")))
        }
        
    }
}
