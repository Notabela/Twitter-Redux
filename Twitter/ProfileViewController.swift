//
//  ProfileViewController.swift
//  Twitter
//
//  Created by daniel on 2/12/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit
import AFNetworking
import LFTwitterProfile

class ProfileViewController: TwitterProfileViewController
{
    
    
    @IBOutlet weak var backButton: UIButton!
    
    var user: TwitterUser!
    {
        didSet
        {
            self.screenName = "@\(user.screenName!)"
            self.locationString = user.location
            self.username = user.name
            self.followersCount = user.followers?.abbreviated
            self.followingCount = user.following?.abbreviated
            
            if let profileImageUrl = user.profileImageUrl
            {
                downloadImageWith(url: profileImageUrl, success: { (image: UIImage?) in
                    self.profileImage = image
                }) { (error: Error?) in
                    print(error!.localizedDescription)
                }
            }
            
            if let coverImageUrl = user.profileCoverImageUrl
            {
                downloadImageWith(url: coverImageUrl, success: { (image: UIImage?) in
                    self.coverImage = image
                }) { (error: Error?) in
                    print(error!.localizedDescription)
                }
            }
            
        }
    }
    
    var userTweets: [Tweet]?

    var tweetTableView: UITableView!
    var photosTableView: UITableView!
    var favoritesTableView: UITableView!
    
    var custom: UIView!
    var label: UILabel!
    
    
    override func numberOfSegments() -> Int {
        return 1
    }
    
    override func segmentTitle(forSegment index: Int) -> String {
        switch index
        {
        case 0: return "Tweets"
        case 1: return "Photos"
        default: return "Tweets"
        }
    }
    
    override func prepareForLayout() {
        // TableViews
        let _tweetTableView = UITableView(frame: CGRect.zero, style: .plain)
        self.tweetTableView = _tweetTableView
        
        let _photosTableView = UITableView(frame: CGRect.zero, style: .plain)
        self.photosTableView = _photosTableView
        
        let _favoritesTableView = UITableView(frame: CGRect.zero, style: .plain)
        self.favoritesTableView = _favoritesTableView
        
        self.setupTables()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubview(toFront: backButton)
    }
    
    @IBAction func onClickBackButton(_ sender: UIButton)
    {
        dismiss(animated: false, completion: nil)
    }
    
    override func scrollView(forSegment index: Int) -> UIScrollView {
        switch index {
        case 0:
            return tweetTableView
        case 1:
            return photosTableView
        case 2:
            return favoritesTableView
        default:
            return tweetTableView
        }
    }

}

// MARK: UITableViewDelegates & DataSources
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func setupTables() {
        self.tweetTableView.delegate = self
        self.tweetTableView.dataSource = self
        self.tweetTableView.register(UINib(nibName: "TwitterTweetCell", bundle: nil), forCellReuseIdentifier: "twitterTweetCell")
        self.tweetTableView.estimatedRowHeight = 500
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        //self.tweetTableView.register(UITableViewCell.self, forCellReuseIdentifier: "tweetCell")
        
        self.photosTableView.delegate = self
        self.photosTableView.dataSource = self
        //self.photosTableView.isHidden = true
        self.photosTableView.register(UITableViewCell.self, forCellReuseIdentifier: "photoCell")
        
        self.favoritesTableView.delegate = self
        self.favoritesTableView.dataSource = self
        //self.favoritesTableView.isHidden = true
        self.favoritesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "favCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tweetTableView:
            return userTweets?.count ?? 0
        case self.photosTableView:
            return 10
        case self.favoritesTableView:
            return 0
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.tweetTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "twitterTweetCell", for: indexPath) as! TwitterTweetCell
            cell.alwaysHideRetweetedView = true
            cell.tweet = userTweets?[indexPath.row]
            return cell
            
        case self.photosTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath)
            cell.textLabel?.text = "Photo \(indexPath.row)"
            return cell
            
        case self.favoritesTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)
            cell.textLabel?.text = "Fav \(indexPath.row)"
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
