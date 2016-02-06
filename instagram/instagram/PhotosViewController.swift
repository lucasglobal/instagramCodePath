//
//  PhotosViewController.swift
//  instagram
//
//  Created by Lucas Andrade on 2/2/16.
//  Copyright © 2016 LucasRibeiro. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    var dataFromRequest: [NSDictionary]?
    var isMoreDataLoading: Bool = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        let scrollInfiniteLoad: InfiniteScrollActivityView
        self.loadData()
        
        //set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let profile = dataFromRequest{
            return profile.count
        }
        return 0
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCel", forIndexPath: indexPath) as! CustomTableViewCell
        let profile = self.dataFromRequest![indexPath.section]
        print(profile)
    

        let imageURLProfile = profile["user"]!["profile_picture"] as! String
        let imageURLPicture = profile["images"]!["standard_resolution"]!!["url"] as! String

        cell.imageBanner.setImageWithURL(NSURL(string: imageURLPicture)!)
        cell.imageProfile.setImageWithURL(NSURL(string: imageURLProfile)!)
        cell.labelProfileName.text = profile["user"]!["full_name"] as? String

        return cell
    }
    //get rid of the gray selection when touching cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(!isMoreDataLoading){
            //calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            //when user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging){
                isMoreDataLoading = true
                
                //update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                self.loadData()
            }
            
            
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailVC = segue.destinationViewController as! DetailViewController
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let profile = self.dataFromRequest![indexPath!.section]
        detailVC.urlPhoto = NSURL(string:profile["images"]!["standard_resolution"]!!["url"] as! String)!

    }
    func loadData(){
        
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.dataFromRequest = responseDictionary["data"] as? [NSDictionary]
                            self.isMoreDataLoading = false
                            self.loadingMoreView!.stopAnimating()
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()

    }
}

