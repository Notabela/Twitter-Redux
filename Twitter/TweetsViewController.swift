//
//  TweetsViewController.swift
//  Twitter
//
//  Created by daniel on 2/3/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, TwitterTweetCellDelegate, ComposeViewControllerDelegate
{
    @IBOutlet weak var tableView: UITableView!
    var loadingMoreView:InfiniteScrollActivityView? //infinite scroll indicator
    
    //var to prevent loading more data when data is already being loaded
    var isMoreDataLoading = false
    var tweets: [Tweet]?
    let client = TwitterClient.sharedInstance

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupTableView()
        setupInfiniteLoadingIndicator()
        setupRefreshControl()
        loadHomeTimeline()
    
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "TwitterLogoBlue"))
    }
    
    //MARK: TableView & TableViewScrollView Delegate Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "twitterTweetCell") as! TwitterTweetCell
        
        cell.tweet = tweets?[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "detailsSegue", sender: tableView.cellForRow(at: indexPath))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        if !isMoreDataLoading
        {
            //set the thresholds
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging)
            {
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                isMoreDataLoading = true
                loadMoreData()
            }
        }
        
    }
    
    //EVENTS
    @IBAction func onLogout(_ sender: Any)
    {
       client?.logout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "detailsSegue"
        {
            let vc = segue.destination as! TweetDetailViewController
            let cell = sender as! TwitterTweetCell
            vc.tweet = cell.tweet
        }
        else if segue.identifier == "profileSegue"
        {
            let vc = segue.destination as! ProfileViewController
            let data = sender as! (user: TwitterUser, tweet: [Tweet])
            vc.user = data.user
            vc.userTweets = data.tweet

        }
        else if segue.identifier == "composeSegue"
        {
            let vc = segue.destination as! ComposeViewController
            vc.delegate = self
        }
    }
    
    //MARK: Private Functions
    internal func loadHomeTimeline()
    {
        client?.homeTimeLine(success: { (tweets: [Tweet]) in
            
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: {
            
            (error: Error) in
            
            print(error)
        })
    }
    
    internal func setupInfiniteLoadingIndicator()
    {
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        //insert it at the bottom
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }
    
    internal func setupRefreshControl()
    {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor(colorLiteralRed: 228/255, green: 228/255, blue: 228/255, alpha: 1)
        refreshControl.tintColor = UIColor(colorLiteralRed: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    internal func setupTableView()
    {
        tableView.register(UINib(nibName: "TwitterTweetCell", bundle: nil), forCellReuseIdentifier: "twitterTweetCell")
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //Tweet Cell delegate Function to Update Cell
    internal func update(cell tableViewCell: TwitterTweetCell)
    {
        
        let indexPath = tableView.indexPath(for: tableViewCell)
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
        tableView.endUpdates()
        
        print("cell was updated")
    }
    
    //Compose View Controller Delegate function
    internal func didTweet(tweet: Tweet)
    {
        tweets?.insert(tweet, at: 0)
        tableView.reloadData()
    }
    
    
    internal func performProfileSegue(cell tableViewCell: TwitterTweetCell)
    {
        print("performing profile segue")
        
        client?.lookupUser(screen_name: tableViewCell.tweet!.screenName!, success: { (user: TwitterUser) in
            
            self.client?.userTimeline(screen_name: user.screenName!, success: { (tweets: [Tweet]) in
                
                self.performSegue(withIdentifier: "profileSegue", sender: (user, tweets))
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })


    }
    
    internal func refreshControlAction(_ sender: UIRefreshControl)
    {
        loadHomeTimeline()
        sender.endRefreshing()
    }
    
    //Load More Data and Append to tweets
    internal func loadMoreData()
    {
        let max_id = tweets!.last!.id - 1
        TwitterClient.sharedInstance?.homeTimeLine(max_id: max_id, success: { (tweets: [Tweet]) in
            
            self.tweets?.append(contentsOf: tweets)
            self.loadingMoreView!.stopAnimating()
            self.isMoreDataLoading = false
            self.tableView.reloadData()
            
        }, failure: {
            
            (error: Error) in
            
            print(error)
        })
    }
}

protocol TwitterTweetCellDelegate: class
{
    func update(cell tableViewCell: TwitterTweetCell)
    func performProfileSegue(cell tableViewCell: TwitterTweetCell)
}

protocol ComposeViewControllerDelegate: class
{
    func didTweet(tweet: Tweet)
}
