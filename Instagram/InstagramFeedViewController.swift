//
//  InstagramFeedViewController.swift
//  Instagram
//
//  Created by Vivian Pham on 3/11/17.
//  Copyright © 2017 Vivian Pham. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class InstagramFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var feed: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Instantiate tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150

        //Reload tableView data
        self.tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //Constructing query
        let query = PFQuery(className: "Post")
        query.order(byDescending: "_created_at")
        query.includeKey("author")
        query.limit = 20
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //Fetching data asynchronously from Parse with PFQuery
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            if let posts = posts {
                self.feed = posts
                self.tableView.reloadData()
                
            }
            else {
                print(error?.localizedDescription ?? "")
            }
        }
        self.tableView.reloadData()
        
        // Hide HUD once the network request comes back
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return feed count for number of cells in tableView
        return feed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        //Initialize caption and username labels from the post
        let post = feed[indexPath.row]
        cell.captionLabel.text = post["caption"] as! String?
        cell.usernameLabel.text = post["username"] as! String?
        
        //Retrieve photo data and update the cell's image with it
        let photo = post["media"] as! PFFile
        photo.getDataInBackground { (data: Data?, error: Error?) in
            if let data = data {
                cell.photoImageView.image = UIImage(data: data)
            }
            else {
                print(error?.localizedDescription ?? "")
            }
        }
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
