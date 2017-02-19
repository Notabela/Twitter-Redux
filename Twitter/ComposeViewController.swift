//
//  ComposeViewController.swift
//  Twitter
//
//  Created by daniel on 2/14/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate
{

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tweetField: UITextView!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var tweetFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBarBottomConstraint: NSLayoutConstraint!
    
    var textViewPlaceholder = "What's happening?"
    weak var delegate: ComposeViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        tweetButton.layer.cornerRadius = 5
        tweetButton.isEnabled = false
        tweetButton.backgroundColor = UIColor.lightGray
        
        tweetField.becomeFirstResponder()
        tweetField.delegate = self
        
        profileImageView.setImageWith(User.currentUser!.profileUrl!)
        profileImageView.layer.cornerRadius = 25
        
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars <= 140
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if textView.text.isEmpty
        {
            tweetButton.isEnabled = false
            tweetButton.backgroundColor = UIColor.lightGray
        } else {
            tweetButton.isEnabled = true
            tweetButton.backgroundColor = UIColor(displayP3Red: 0, green: 160/255, blue: 252/255, alpha: 1)
        }
        
        countLabel.text = "\(140 - textView.text!.characters.count)"
    }
    
    
    func keyboardWillShow(_ notification: NSNotification!)
    {
        //keyboard dimensions
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        bottomBarBottomConstraint.constant = frame.height

    }
    
    func keyboardWillHide(_ notification: NSNotification!)
    {
         bottomBarBottomConstraint.constant = 1
    }
    
    
    @IBAction func didTweet(_ sender: Any)
    {
        print("Did tweet")
        let tweetText  = tweetField.text!
        
        TwitterClient.sharedInstance?.updateStatus(tweet: tweetText, success: {
            
            (tweet: Tweet) in
            
            self.delegate?.didTweet(tweet: tweet)
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
            
        }, failure: { (error: Error) in
            
            print(error.localizedDescription)
        })
    }

    @IBAction func didCancel(_ sender: Any)
    {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

}
