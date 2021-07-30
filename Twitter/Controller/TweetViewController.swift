//
//  TweetViewController.swift
//  Twitter
//
//  Created by Luis Brito on 7/27/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView! {
        didSet {
            tweetTextView.layer.borderWidth = 1
            tweetTextView.text = "What's on your mind?"
            tweetTextView.textColor = UIColor.lightGray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // To put a place holder text into the UITextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        let textView = tweetTextView
        if textView?.textColor == UIColor.lightGray {
            textView?.text = nil
            textView?.textColor = UIColor.black
        }
    }
    // To put a place holder text into the UITextView
    func textViewDidEndEditing(_ textView: UITextView) {
        let textView = tweetTextView
        if ((textView?.text.isEmpty) != nil) {
            textView?.text = "What's on your mind?"
            textView?.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func tweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: { self.dismiss(animated: true, completion: nil)
                
            }, failure: { (error) in
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
