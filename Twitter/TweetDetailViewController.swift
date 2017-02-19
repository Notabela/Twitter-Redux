//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by daniel on 2/12/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController
{
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var isRetweetedIcon: UIImageView!
    @IBOutlet weak var isRetweetedLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var profileViewtoViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileViewtoisRetweetLabelConstraint: NSLayoutConstraint!
    
    var tweet: Tweet?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = tweet?.user
        handleLabel.text = "@\((tweet?.screenName)!)"
        timeStampLabel.text = tweet?.longTimeStamp
        messageLabel.text = tweet?.text
        isRetweetedLabel.text = "\((tweet?.retweetUserScreenName)!) Retweeted"
        if let imageUrl = tweet?.userProfileImage
        {
            profileView.setImageWith(imageUrl)
        }
        
        profileView.layer.cornerRadius = 5
        
        updateCellStates()
    }
    
    //MARK: Private Functions
    func updateCellStates()
    {
        isRetweetedLabel.isHidden = !tweet!.isRetweeted!
        isRetweetedIcon.isHidden = !tweet!.isRetweeted!
        profileViewtoViewConstraint.priority = tweet!.isRetweeted! ? 200 : 999
        profileViewtoisRetweetLabelConstraint.priority = tweet!.isRetweeted! ? 999 : 200
        
        retweetLabel.text = tweet?.retweetCount.abbreviated
        likesLabel.text = tweet?.favoritesCount.abbreviated
        
        retweetButton.isSelected =  tweet!.isRetweetedbyUser! ? true : false
        favoriteButton.isSelected = tweet!.isFavoritedbyUser! ? true : false
    }


}
