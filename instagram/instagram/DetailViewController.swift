//
//  DetailViewController.swift
//  instagram
//
//  Created by Lucas Andrade on 2/5/16.
//  Copyright © 2016 LucasRibeiro. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageBanner: UIImageView!
    var urlPhoto: NSURL = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageBanner.setImageWithURL(urlPhoto)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
