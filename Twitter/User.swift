//
//  User.swift
//  Twitter
//
//  Created by daniel on 2/2/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit

class User: NSObject
{
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var tagline: String?
    
    var dictionary: Dictionary<String, Any>?
    
    init(_ dictionary: Dictionary<String, Any>)
    {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString
        {
            self.profileUrl = URL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
    }
    
    static let userDidLogoutNotification = "UserdidLogout"
    static var _currentUser: User?
    
    class var currentUser: User?
    {
        get
        {
            if _currentUser == nil
            {
                let defaults = UserDefaults.standard
                if let userData = defaults.object(forKey: "currentUserData") as? Data
                {
                    let dictionary = try!
                        JSONSerialization.jsonObject(with: userData, options: []) as! Dictionary<String, Any>
                    
                   _currentUser = User(dictionary)
                }
            }
            
            return _currentUser
        }
        
        set (user)
        {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user
            {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            }
            else
            {
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}
