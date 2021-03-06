//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Luis Brito on 7/23/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweets = Int()
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadTweets()
        
        // For pull down refresh to work.
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        
        // Tell table which refresh control to use
        tableView.refreshControl = myRefreshControl
    }
    
    // In order to reload once this view appers, since the viewDidLoad is only called once the controller is called into memory
    override func viewDidAppear(_ animated: Bool) {
        // Call super class first to make sure it does any of the cycle necessary.
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    
    @objc func loadTweets(){
        numberOfTweets = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        // Parameters for the request (add as needed)
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            // Empty array of tweets before loading new ones into it
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print(Error.localizedDescription)
        })
        
        
    }
    
    func loadMoreTweets() {
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        numberOfTweets += 20
        
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            // Empty array of tweets before loading new ones into it
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print(Error.localizedDescription)
            
        })
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // To trigger loadMoreTweets when approaching the end of the table view
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        
        // To get the view to disappear (dismiss) itself.
        self.dismiss(animated: true, completion: nil)
        
        // In order to tell the app how to proceed when user logs out.
        UserDefaults.standard.setValue(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let tweet = tweetArray[indexPath.row]
        
        let user = tweet["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
            
        cell.tweetTextLabel.text = tweet["text"] as? String

        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!.replacingOccurrences(of: "_normal", with: "", options: NSString.CompareOptions.literal, range: nil))
        
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorite(tweet["favorited"] as! Bool)
        cell.tweetId = tweet["id"] as! Int
        cell.setRetweet(tweet["retweeted"] as! Bool)
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        return cell
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
