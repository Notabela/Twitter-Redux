//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by daniel on 2/6/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit
import AFNetworking

class TwitterTweetCell: UITableViewCell
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
    
    //Delegate to Communicate with TweetsViewController
    weak var delegate: TwitterTweetCellDelegate?
    var alwaysHideRetweetedView: Bool = false
    
    //Twitter Client
    var client = TwitterClient.sharedInstance
    
    var tweet: Tweet?
    {
        didSet
        {
            nameLabel.text = tweet?.user
            handleLabel.text = "@\((tweet?.screenName)!)"
            timeStampLabel.text = tweet?.shortTimeStamp
            messageLabel.text = tweet?.text
            isRetweetedLabel.text = "\((tweet?.retweetUserScreenName)!) Retweeted"
            if let imageUrl = tweet?.userProfileImage
            {
                profileView.setImageWith(imageUrl)
            }
            
            updateCellStates()
        }
        
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        let touchRecognizer = UITapGestureRecognizer()
        touchRecognizer.addTarget(self, action: #selector(didTapProfileView))
        profileView.addGestureRecognizer(touchRecognizer)
        
        profileView.layer.cornerRadius = 5
        
    }
    
    func updateCellStates()
    {
        
        guard !alwaysHideRetweetedView else
        {
            isRetweetedLabel.isHidden = true
            isRetweetedIcon.isHidden = true
            profileViewtoViewConstraint.priority = 999
            profileViewtoisRetweetLabelConstraint.priority = 200
            return
        }
        
        isRetweetedLabel.isHidden = !tweet!.isRetweeted!
        isRetweetedIcon.isHidden = !tweet!.isRetweeted!
        profileViewtoViewConstraint.priority = tweet!.isRetweeted! ? 200 : 999
        profileViewtoisRetweetLabelConstraint.priority = tweet!.isRetweeted! ? 999 : 200
        
        retweetLabel.text = tweet?.retweetCount.abbreviated
        likesLabel.text = tweet?.favoritesCount.abbreviated
        
        retweetButton.isSelected =  tweet!.isRetweetedbyUser! ? true : false
        favoriteButton.isSelected = tweet!.isFavoritedbyUser! ? true : false
    }
    
    func didTapProfileView()
    {
        delegate?.performProfileSegue(cell: self)
    }
    
    @IBAction func didRetweet(_ sender: UIButton)
    {
        if tweet!.isRetweetedbyUser!
        {
            performTweetAction(ofType: client!.unRetweet, success: {
                self.tweet?.isRetweetedbyUser = false
                self.tweet?.retweetCount -= 1
            })
            
        } else {
            
            performTweetAction(ofType: client!.retweet, success: {
                self.tweet?.isRetweetedbyUser = true
                self.tweet?.retweetCount += 1
            })
        }
        
    }
    
    
    @IBAction func didFavorite(_ sender: UIButton)
    {
        if tweet!.isFavoritedbyUser!
        {
            performTweetAction(ofType: client!.unFavorite, success: {
                self.tweet?.isFavoritedbyUser = false
                self.tweet?.favoritesCount -= 1
            })
            
        } else {
            
            performTweetAction(ofType: client!.favorite, success: {
                self.tweet?.isFavoritedbyUser = true
                self.tweet?.favoritesCount += 1
            })
            
        }
    }
    
    func performTweetAction(ofType tweetAction: (Int64, @escaping (Tweet) -> (), @escaping (Error) -> ()) -> (), success: @escaping () -> ())
    {
        tweetAction(tweet!.id, { (tweet: Tweet) in
            
            success()
            self.updateCellStates()
            self.delegate?.update(cell: self)
            
        }) { (error: Error) in
            
            print(error.localizedDescription)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
