//
//  CustomTableViewCell.swift
//  instagram
//
//  Created by Lucas Andrade on 2/2/16.
//  Copyright © 2016 LucasRibeiro. All rights reserved.
//

import UIKit
import AFNetworking

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var imageBanner: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
